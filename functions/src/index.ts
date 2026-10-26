//  index.ts
//  AgroShare
//
//  Create by Vinicius Bruno on 23/10/2026
//
//  Push notifications disparadas por mudanças no Firestore.
//  O app (lib/core/services/notification_service.dart) salva os
//  tokens em users/{uid}.fcmTokens e usa `data.tipo` para abrir a tela certa.

import { initializeApp } from "firebase-admin/app";
import { FieldValue, getFirestore } from "firebase-admin/firestore";
import { getMessaging } from "firebase-admin/messaging";
import { logger } from "firebase-functions";
import { setGlobalOptions } from "firebase-functions/v2";
import {
  onDocumentCreated,
  onDocumentUpdated,
} from "firebase-functions/v2/firestore";

initializeApp();

// Firestore em nam5 => funções em us-central1
setGlobalOptions({ region: "us-central1", maxInstances: 10 });

const db = getFirestore();

const REQUEST_PATH = "users/{ownerId}/equipamentos/{equipamentoId}/requests/{requesterId}";

/** Nova solicitação de aluguel => avisa o dono do equipamento. */
export const onNovaSolicitacao = onDocumentCreated(REQUEST_PATH, async (event) => {
  const request = event.data?.data();
  if (!request) return;

  const { ownerId, equipamentoId } = event.params;
  const nomeEquipamento = await getNomeEquipamento(ownerId, equipamentoId);

  await notify(ownerId, {
    title: "Nova solicitação de aluguel",
    body: `${request.name ?? "Alguém"} quer alugar ${nomeEquipamento}`,
    data: { tipo: "solicitacao", ownerId, equipamentoId },
  });
});

/** Solicitação aceita (accept false => true) => avisa quem solicitou. */
export const onSolicitacaoAceita = onDocumentUpdated(REQUEST_PATH, async (event) => {
  const before = event.data?.before.data();
  const after = event.data?.after.data();
  if (!after || before?.accept === true || after.accept !== true) return;

  const { ownerId, equipamentoId, requesterId } = event.params;
  const nomeEquipamento = await getNomeEquipamento(ownerId, equipamentoId);

  await notify(requesterId, {
    title: "Solicitação aceita!",
    body: `Seu pedido de aluguel de ${nomeEquipamento} foi aceito`,
    data: { tipo: "aceite", ownerId, equipamentoId },
  });
});

/** Nova mensagem no chat => avisa o outro participante. */
export const onNovaMensagem = onDocumentCreated(
  "chats/{chatId}/messages/{messageId}",
  async (event) => {
    const message = event.data?.data();
    if (!message) return;

    const { chatId } = event.params;
    const chat = (await db.doc(`chats/${chatId}`).get()).data();
    if (!chat) return;

    const participants: string[] = chat.participants ?? [];
    const destino = participants.find((uid) => uid !== message.senderId);
    if (!destino) return;

    // quem enviou vira o "contato" do chat que será aberto pelo destinatário
    const sender = (await db.doc(`users/${message.senderId}`).get()).data();
    const senderName: string = sender?.name ?? "Nova mensagem";

    await notify(destino, {
      title: senderName,
      body: `${chat.nome_equipamento}: ${message.text}`,
      data: {
        tipo: "chat",
        chatId,
        equipamentoId: chat.equipamentoId,
        ownerId: chat.ownerId,
        requesterId: chat.requesterId,
        nome_equipamento: chat.nome_equipamento ?? "",
        contactName: senderName,
        contactPhoto: sender?.photo ?? "",
      },
    });
  },
);

async function getNomeEquipamento(ownerId: string, equipamentoId: string) {
  const equipamento = await db
    .doc(`users/${ownerId}/equipamentos/${equipamentoId}`)
    .get();

  return (equipamento.data()?.nome_equipamento as string) ?? "seu equipamento";
}

interface Notificacao {
  title: string;
  body: string;
  data: Record<string, string>;
}

/** Envia para todos os aparelhos do usuário e limpa tokens inválidos. */
async function notify(uid: string, { title, body, data }: Notificacao) {
  const userRef = db.doc(`users/${uid}`);
  const tokens: string[] = (await userRef.get()).data()?.fcmTokens ?? [];

  if (tokens.length === 0) return;

  const response = await getMessaging().sendEachForMulticast({
    tokens,
    notification: { title, body },
    data,
    android: { priority: "high", notification: { sound: "default" } },
    apns: { payload: { aps: { sound: "default" } } },
  });

  const invalidos = tokens.filter((_, index) => {
    const code = response.responses[index].error?.code;
    return (
      code === "messaging/registration-token-not-registered" ||
      code === "messaging/invalid-registration-token"
    );
  });

  if (invalidos.length > 0) {
    await userRef.update({ fcmTokens: FieldValue.arrayRemove(...invalidos) });
  }

  logger.info(`notify ${data.tipo} => ${uid}`, {
    enviados: response.successCount,
    falhas: response.failureCount,
  });
}
