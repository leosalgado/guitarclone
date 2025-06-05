import socket
import threading
import json

clients = []
ready_count = 0
lock = threading.Lock()
scores = {}


def handle_client(conn, addr):
    global ready_count
    while True:
        data = conn.recv(1024).decode()
        if not data:
            print(f"Conexão encerrada pelo cliente {addr}.")
            break
        # print(f"Recebido: {repr(data)}")
        if data.strip() == "ready":
            with lock:
                ready_count += 1
                print(f"Jogador pronto ({ready_count}/{len(clients)})")
                if ready_count == len(clients):
                    for c in clients:
                        c.sendall(b"start\n")
                    print("Start!")
        elif "," in data.strip():
            # print(data.strip())
            parts = data.split(",")
            if len(parts) == 2:
                client_id = parts[0].strip()
                score_str = parts[1].strip()
                if score_str.isdigit():
                    with lock:
                        scores[client_id] = int(score_str)
                        print(scores)
                        data = json.dumps(scores) + "\n"
                        for c in clients:
                            try:
                                c.sendall(data.encode())
                            except:
                                pass
                        # print(f"Score de {client_id}: {score_str}")
                else:
                    print(f"Score inválido: {score_str}")
            else:
                print("Formato inválido:", data)
    conn.close()
    with lock:
        if conn in clients:
            clients.remove(conn)
            remove_client_id = f"{addr[0]}:{addr[1]}"
            if remove_client_id in scores:
                del scores[remove_client_id]
                print(f"Score de {remove_client_id} removido.")
            # Ajusta o ready_count se um cliente sair antes de dar ready
            if ready_count > len(clients):
                ready_count = len(clients)


server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server.bind(("0.0.0.0", 9000))
server.listen()

print("Servidor aguardando conexões...")

while True:
    conn, addr = server.accept()
    print(f"Conectado com {addr}")

    ip, port = addr
    client_id = f"{ip}:{port}\n"

    conn.sendall(client_id.encode())

    with lock:
        clients.append(conn)
    threading.Thread(target=handle_client, args=(conn, addr), daemon=True).start()
