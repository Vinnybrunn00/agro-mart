"""
 * scripts/lib/memory/mem_test/mem.py
 *
 * Teste de consumo de memória com tracemalloc.
 *
 * Copyright (C) 2026 Vinícius Bruno <vinibruno.dev@gmail.com>
 *
 * Created on 02/11/2026
"""

import tracemalloc

tracemalloc.start()

# Gera uma lista grande só para consumir memória
dados = [i ** 2 for i in range(1_000_000)]

# Memória atual e pico alocados
atual, pico = tracemalloc.get_traced_memory()
print(f"Atual: {atual / 1024**2:.2f} MB | Pico: {pico / 1024**2:.2f} MB")

# Top 5 linhas que mais alocaram memória
snapshot = tracemalloc.take_snapshot()
for stat in snapshot.statistics("lineno")[:5]:
    print(stat)

tracemalloc.stop()