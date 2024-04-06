import re
import sys

def extraire_informations(fichier):
    with open(fichier, 'r') as f:
        texte = f.read()

    # Extraire les informations nécessaires
    adresse_ip = re.search(r"kubeadm join (\d+\.\d+\.\d+\.\d+:\d+)", texte).group(1)
    token = re.search(r"--token (\S+)", texte).group(1)
    cert_hash = re.search(r"--discovery-token-ca-cert-hash (\S+)", texte).group(1)
    certificate_key = re.search(r"--certificate-key (\S+)", texte).group(1)

    # Générer les contenus pour les fichiers
    master_content = (f"kubeadm join {adresse_ip} --token {token} \\\n"
                      f"\t--discovery-token-ca-cert-hash {cert_hash} \\\n"
                      f"\t--control-plane --certificate-key {certificate_key}\n")
    worker_content = (f"kubeadm join {adresse_ip} --token {token} \\\n"
                      f"\t--discovery-token-ca-cert-hash {cert_hash}\n")

    return master_content, worker_content

def creer_fichiers(master_content, worker_content):
    # Écrire les contenus dans les fichiers
    with open('masterJoin.sh', 'w') as master_file:
        master_file.write(master_content)
    with open('workerJoin.sh', 'w') as worker_file:
        worker_file.write(worker_content)

    print("Les fichiers 'masterJoin.sh' et 'workerJoin.sh' ont été créés avec succès.")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python creer_fichiers_kubeadm.py chemin/du/fichier/aextraire")
    else:
        chemin_fichier = sys.argv[1]
        master_content, worker_content = extraire_informations(chemin_fichier)
        creer_fichiers(master_content, worker_content)
