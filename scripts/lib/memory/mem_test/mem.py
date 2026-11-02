import tracemalloc

tracemalloc.start()

dados = [i ** 2 for i in range(1_000_000)]

atual, pico = tracemalloc.get_traced_memory()
print(f"Atual: {atual / 1024**2:.2f} MB | Pico: {pico / 1024**2:.2f} MB")

snapshot = tracemalloc.take_snapshot()
for stat in snapshot.statistics("lineno")[:5]:
    print(stat)

tracemalloc.stop()