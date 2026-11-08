# scripts

Scripts auxiliares em Python para o desenvolvimento do **agro-mart**: informações do sistema (disco, hardware, memória), monitoramento de desempenho do app Flutter em um dispositivo Android e utilitários de build e busca no código.

## Estrutura

```
scripts/
├── main.py                     # Coleta informações de disco, hardware e memória
├── lib/
│   ├── disk/disk.py            # Classe Disk: espaço total, usado e livre
│   ├── hardware/hardware.py    # Classe Hardware: sistema, CPU e temperatura
│   └── memory/
│       ├── memory.py           # Classe Memory: uso de RAM e top 10 processos
│       └── mem_test/mem.py     # Teste de consumo de memória com tracemalloc
├── monitor/
│   └── monitor_memory_cpu_device_debug_flutter_app.py  # CPU/memória do app via adb → CSV
└── utils/
    ├── build_apk.py            # Executa `flutter build apk`
    └── search/
        ├── search.py           # Lista arquivos de lib/ por extensão
        └── search_code.py      # Procura um trecho de código nos arquivos de lib/
```

## Requisitos

- Python 3.10+
- [`psutil`](https://pypi.org/project/psutil/) (usado em `lib/`)
- `adb` (Android SDK Platform Tools) no `PATH`, para o monitor
- Flutter SDK no `PATH`, para o build

```bash
pip install psutil
```

## Uso

### Informações do sistema — `main.py`

Execute a partir da pasta `scripts/` para que os imports de `lib/` funcionem:

```bash
cd scripts
python3 main.py
```

As classes também podem ser usadas diretamente:

```python
from lib.disk.disk import Disk
from lib.hardware.hardware import Hardware
from lib.memory.memory import Memory

print(Disk().disk_free_GB())               # Livre: 120 GB
print(Hardware().current_cpu_frequence())  # Atual: 2400.00 MHz
print(Memory().memory_percent())           # 43.2 %
```

| Classe     | Métodos principais |
|------------|--------------------|
| `Disk`     | `disk_total_GB`, `disk_used_GB`, `disk_free_GB` |
| `Hardware` | `device_name`, `system_name`, `system_version`, `system_architecture`, `system_type`, `cpu_count`, `current_cpu_frequence`, `max_cpu_frequence`, `min_cpu_frequence`, `cpu_temperature_current`, `cpu_temperature_high`, `cpu_temperature_critical`, `cpu_temperature_current_stream` |
| `Memory`   | `memory_total`, `memory_used`, `memory_free`, `memory_percent`, `memory_usage` (top 10 processos) |

> Frequência e temperatura da CPU só funcionam no **Linux**. A temperatura é lida do sensor `acpitz`.

### Monitor de CPU e memória do app — `monitor/`

Lê o uso de CPU (`top`) e memória PSS (`dumpsys meminfo`) do app em execução no dispositivo conectado, a cada 1 segundo, e grava em CSV.

```bash
python3 monitor/monitor_memory_cpu_device_debug_flutter_app.py <package.do.app>
```

- O app precisa estar rodando no dispositivo (`adb devices` deve listá-lo).
- A saída vai para `flutter_logs/perf_AAAA-MM-DD_HH-MM.csv`, relativo ao diretório atual, com as colunas `horario`, `cpu_%`, `memoria_mb`.
- Pressione `Ctrl+C` para parar.

### Build do APK — `utils/build_apk.py`

Roda `flutter build apk` e mostra a saída. Execute a partir da raiz do projeto Flutter:

```bash
python3 scripts/utils/build_apk.py
```

### Busca no código — `utils/search/`

As classes percorrem `../../lib/`, portanto devem ser usadas com `utils/search/` como diretório atual.

```python
from search import SearchExtensionFiles
from search_code import SearchSintaxForDart

SearchExtensionFiles('.dart').search()          # lista arquivos .dart
SearchSintaxForDart('StatefulWidget').scan_file()  # arquivos que contêm o trecho
```

### Teste de memória — `lib/memory/mem_test/mem.py`

Exemplo de uso do `tracemalloc`: mostra a memória atual, o pico e as 5 linhas que mais alocaram.

```bash
python3 lib/memory/mem_test/mem.py
```
