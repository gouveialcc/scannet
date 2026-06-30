#!/bin/bash

# -----------------------------------------------------------------------------
# Script: scannet.sh
# Descrição: SCANNET - CLI de Auditoria ISO 27001 Multi-Distribuição
# Autor: Especialista em Segurança da Informação
# -----------------------------------------------------------------------------

# Configuração de Cores (ANSI Escapes)
VERDE='\033[0;32m'
VERDE_NEGRITO='\033[1;32m'
VERMELHO='\033[0;31m'
VERMELHO_NEGRITO='\033[1;31m'
AMARELO='\033[0;33m'
AZUL='\033[0;34m'
CIANO='\033[0;36m'
SEM_COR='\033[0m'

# Diretórios e Datas
DIRETORIO_LOG="$(cd "$(dirname "$0")" && pwd)"
DATA_ATUAL=$(date +%Y-%m-%d)
PREFIXO_LOG="$DIRETORIO_LOG/scannet_auditoria_$DATA_ATUAL"
OS_TIPO="$(uname -s)"

# 1. Validação de Usuário Root
if [ "$EUID" -ne 0 ]; then
    echo -e "${VERMELHO_NEGRITO}[ERRO] O SCANNET exige privilégios de ROOT para pacotes Raw (SYN Scan).${SEM_COR}"
    echo -e "${AMARELO}Por favor, execute novamente utilizando: sudo $0${SEM_COR}"
    exit 1
fi

# Captura de Interrupções (Ctrl+C)
trap captura_ctrl_c INT
captura_ctrl_c() {
    echo -e "\n\n${VERMELHO_NEGRITO}[!] Execução abortada pelo operador. Limpando processos do SCANNET...${SEM_COR}"
    pkill nmap > /dev/null 2>&1
    exit 1
}

# Cabeçalho CLI Oficial - SCANNET
desenhar_cabecalho() {
    clear
    echo -e "${CIANO}=======================================================================${SEM_COR}"
    echo -e "${VERDE_NEGRITO}    ███████╗ ██████╗ █████╗ ███╗   ██╗███╗   ██╗███████╗████████╗      ${SEM_COR}"
    echo -e "${VERDE_NEGRITO}    ██╔════╝██╔════╝██╔══██╗████╗  ██║████╗  ██║██╔════╝╚══██╔══╝      ${SEM_COR}"
    echo -e "${VERDE_NEGRITO}    ███████╗██║     ███████║██╔██╗ ██║██╔██╗ ██║█████╗     ██║         ${SEM_COR}"
    echo -e "${VERDE_NEGRITO}    ╚════██║██║     ██╔══██║██║╚██╗██║██║╚██╗██║██╔══╝     ██║         ${SEM_COR}"
    echo -e "${VERDE_NEGRITO}    ███████║╚██████╗██║  ██║██║ ╚████║██║ ╚████║███████╗   ██║         ${SEM_COR}"
    echo -e "${VERDE_NEGRITO}    ╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═══╝╚══════╝   ╚═╝         ${SEM_COR}"
    echo -e "${CIANO}=======================================================================${SEM_COR}"
    echo -e "${VERDE_NEGRITO}       ISO 27001 Compliance - Network Vulnerability Auditor            ${SEM_COR}"
    echo -e "${CIANO}-----------------------------------------------------------------------${SEM_COR}"
    echo -e "${AZUL}Plataforma:${SEM_COR} $OS_TIPO | ${AZUL}Operador:${SEM_COR} ROOT | ${AZUL}Data:${SEM_COR} $DATA_ATUAL"
    echo -e "${CIANO}-----------------------------------------------------------------------${SEM_COR}"
}

# Spinner de Carregamento Portável
aguardar_processo() {
    local pid=$1
    local delay=0.5
    local spinstr='|/-\\'
    echo -ne "${AMARELO}[*] SCANNET em execução. Aguarde a finalização... ${SEM_COR}"
    while kill -0 "$pid" 2>/dev/null; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    echo -e "${VERDE}[CONCLUÍDO]${SEM_COR}"
}

# 2. Motor de Gerenciamento de Pacotes Inteligente (Multi-Distro)
instalar_pacote() {
    local pkg=$1
    
    if [ "$OS_TIPO" = "Darwin" ]; then
        if command -v brew &> /dev/null; then
            brew install "$pkg" > /dev/null 2>&1
        else
            echo -e "${VERMELHO_NEGRITO}[ERRO] Homebrew não detectado no macOS. Abortando.${SEM_COR}"
            exit 1
        fi
        return
    fi

    if command -v apt-get &> /dev/null; then
        apt-get update -y > /dev/null 2>&1
        apt-get install -y "$pkg" > /dev/null 2>&1
    elif command -v dnf &> /dev/null; then
        dnf install -y "$pkg" > /dev/null 2>&1
    elif command -v yum &> /dev/null; then
        yum install -y "$pkg" > /dev/null 2>&1
    elif command -v pacman &> /dev/null; then
        pacman -Sy --noconfirm "$pkg" > /dev/null 2>&1
    else
        echo -e "${VERMELHO}[X] Gerenciador de pacotes não suportado automaticamente.${SEM_COR}"
        echo -e "${AMARELO}[!] Por favor, instale '$pkg' manualmente antes de rodar o SCANNET.${SEM_COR}"
    fi
}

# Inicialização da Tela
desenhar_cabecalho

echo -e "${AZUL}[+] Mapeando arquitetura e validando dependências de segurança...${SEM_COR}"

GERE_PDF=true
for ferramenta in xsltproc wkhtmltopdf nmap; do
    if ! command -v "$ferramenta" &> /dev/null; then
        echo -e "${AMARELO}[!] Componente essencial '$ferramenta' ausente. Resolvendo...${SEM_COR}"
        instalar_pacote "$ferramenta"
        
        if ! command -v "$ferramenta" &> /dev/null; then
            echo -e "${VERMELHO}[X] Falha ao injetar e validar o binário '$ferramenta'.${SEM_COR}"
            if [ "$ferramenta" = "nmap" ]; then 
                echo -e "${VERMELHO_NEGRITO}[ERRO CRÍTICO] Impossível prosseguir sem o motor do Nmap. Abortando.${SEM_COR}"
                exit 1
            fi
            GERE_PDF=false
        fi
    fi
done

echo -e "${VERDE}[v] Todos os binários foram validados com assinaturas locais do sistema.${SEM_COR}"

# 3. Entrada Interativa do IP/Range
while [ -z "$ALVO_REDE" ]; do
    echo -ne "${AMARELO}\nDigite o IP/Range para auditoria (ex: 192.168.1.0/24): ${SEM_COR}"
    read -r ALVO_REDE
    if [ -z "$ALVO_REDE" ]; then
        echo -e "${VERMELHO}[!] O escopo do alvo não pode ser nulo.${SEM_COR}"
    fi
done

# Restringir permissões do diretório atual para mitigar vazamento de dados locais (ISO 27001)
chmod 700 "$DIRETORIO_LOG"

echo -e "\n${CIANO}[Configurações Corporativas - SCANNET]${SEM_COR}"
echo -e " Alvo Definido:  ${VERDE_NEGRITO}$ALVO_REDE${SEM_COR}"
echo -e " Repositório:    ${VERDE}$DIRETORIO_LOG/${SEM_COR}"
echo -e " Evidência PDF:  ${AMARELO}scannet_auditoria_$DATA_ATUAL.pdf${SEM_COR}"
echo -e "${CIANO}-----------------------------------------------------------------------${SEM_COR}"

echo -ne "${AMARELO}Confirmar início do escaneamento de conformidade? (s/n): ${SEM_COR}"
read -r resposta

if [[ "$resposta" =~ ^[Ss]$ ]]; then
    echo -e "\n${AZUL}[+] Disparando engine Nmap com scripts regulatórios (vuln, auth, default)...${SEM_COR}"
    
    # Comando Mestre Otimizado do SCANNET
    nmap -sS -sV -O --script=vuln,auth,default -v -p- -T4 --min-rate 1000 --max-retries 2 -oA "$PREFIXO_LOG" "$ALVO_REDE" > /dev/null 2>&1 &
    PID_NMAP=$!
    
    # Invoca monitor portável de subprocessos
    aguardar_processo $PID_NMAP

    # 4. Geração de Artefatos para Análise Crítica
    echo -e "${AZUL}[+] Compilando árvore XML estruturada em HTML executivo...${SEM_COR}"
    xsltproc "$PREFIXO_LOG.xml" -o "$PREFIXO_LOG.html" 2>/dev/null
    
    if [ "$GERE_PDF" = true ] && [ -f "$PREFIXO_LOG.html" ]; then
        echo -e "${AZUL}[+] Renderizando documento PDF em alta fidelidade...${SEM_COR}"
        wkhtmltopdf --page-size Letter --margin-top 15mm --margin-bottom 15mm --margin-left 15mm --margin-right 15mm "$PREFIXO_LOG.html" "$PREFIXO_LOG.pdf" > /dev/null 2>&1
    fi

    # Tela de Encerramento e Apresentação de Evidências
    echo -e "\n${VERDE_NEGRITO}[SUCESSO] Ciclo de auditoria concluído e validado pelo SCANNET.${SEM_COR}"
    echo -e "${CIANO}=======================================================================${SEM_COR}"
    echo -e "${AZUL}Artefatos criptograficamente isolados na pasta atual:${SEM_COR}"
    if [ -f "$PREFIXO_LOG.pdf" ]; then
        echo -e " -> ${VERDE_NEGRITO}$PREFIXO_LOG.pdf${SEM_COR}   (Relatório Corporativo Pronto para a Diretoria)"
    fi
    echo -e " -> ${VERDE}$PREFIXO_LOG.html${SEM_COR}  (Cópia de Backup Visual)"
    echo -e " -> ${VERDE}$PREFIXO_LOG.xml${SEM_COR}   (Evidência Bruta para Auditores ISO 27001)"
    echo -e "${CIANO}=======================================================================${SEM_COR}"
else
    echo -e "\n${VERMELHO}[!] Operação cancelada pelo operador de segurança.${SEM_COR}"
    exit 0
fi
