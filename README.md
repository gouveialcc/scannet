# 🛡️ SCANNET — Enterprise Vulnerability Auditor CLI

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform Support](https://img.shields.io/badge/platform-Ubuntu%20%7C%20Fedora%20%7C%20CentOS%20%7C%20Arch%20%7C%20macOS-blue)](https://github.com/)
[![Security Engine](https://img.shields.io/badge/Engine-Nmap%20NSE-orange)](https://nmap.org/)
[![Project Type](https://img.shields.io/badge/Project-Open%20Source%20%2F%20Non--Profit-brightgreen)](https://github.com/)

O **SCANNET** é uma interface profissional em linha de comando (CLI) projetada para automatizar auditorias internas de rede e gestão de vulnerabilidades. Desenvolvido especificamente para atender aos requisitos de **Análise Crítica e Melhoria Contínua da ISO 27001**, este script transforma o poder do Nmap em uma solução corporativa robusta, gerando relatórios executivos estruturados em formatos técnicos e visuais (HTML/PDF).

Este é um projeto **100% open-source, livre e sem fins lucrativos**, mantido de forma independente com o propósito de ajudar a comunidade global de administradores de sistemas, analistas de segurança e equipes de infraestrutura de TI.

---

## 🎯 Propósito do Projeto

Em auditorias de certificação **ISO 27001**, a rastreabilidade, integridade das evidências e a execução periódica de testes de segurança são obrigatórias. Muitas equipes de TI e pequenas empresas enfrentam barreiras operacionais e financeiras devido ao alto custo de ferramentas proprietárias de scan de vulnerabilidades.

O propósito do **SCANNET** é **democratizar a auditoria de segurança de nível corporativo**. Como uma iniciativa estritamente sem fins lucrativos, o script apoia organizações que necessitam validar sua postura de segurança sem comprometer o orçamento. Utilizando apenas o consagrado **Nmap** como motor de varredura homologado, a ferramenta automatiza todo o processo técnico, valida dependências dinamicamente em múltiplos sistemas operacionais, protege os dados locais coletados e entrega um **Relatório Executivo em PDF com sugestões de remediação, referências CVE e links de patches** pronto para ser apresentado à diretoria e aos auditores.

---

## 📋 Especificação Técnica do Sistema Operacional

A ferramenta foi cirurgicamente adaptada, testada e homologada para garantir compatibilidade nativa (possuindo suporte a gerenciadores de pacotes específicos e tratamento de chamadas de sistema GNU/BSD) nos seguintes ambientes:

### 🐧 Distribuições Linux (Arquiteturas x86_64 / ARM64)
* **Família Debian / Ubuntu:** Totalmente adaptado para **Ubuntu Server (incluindo 24.04 LTS e posteriores)**, Ubuntu Desktop, Debian GNU/Linux e Linux Mint.
  * *Gerenciador nativo utilizado:* `apt-get`.
* **Família Red Hat (RHEL) / Enterprise Linux:**
  * Adaptado para distribuições modernas como **Fedora (Workstation e Server)**, **Rocky Linux**, **AlmaLinux** e **CentOS Stream**.
  * *Gerenciador nativo utilizado:* `dnf`.
  * Adaptado para sistemas legados como **CentOS 7/8** e versões anteriores do Red Hat Enterprise Linux.
  * *Gerenciador nativo utilizado:* `yum`.
* **Família Arch Linux:**
  * Adaptado para **Arch Linux** e Manjaro, garantindo execução em sistemas *rolling release*.
  * *Gerenciador nativo utilizado:* `pacman`.

### 🍏 Apple macOS (Unix-BSD)
* **Compatibilidade de Arquitetura:** Homologado tanto para chips **Apple Silicon (M1, M2, M3, M4)** quanto para processadores **Intel**.
* **Adaptação de Core:** O script reconstrói dinamicamente loops de monitoramento de processos para substituir comandos restritos ao Linux, tornando-os 100% compatíveis com o ecossistema BSD do Mac.
* *Gerenciador nativo utilizado:* `Homebrew (brew)`.

---

## ✨ Funcionalidades Principais

* **Multi-Plataforma Nativo:** Inteligência de pacotes que mapeia a arquitetura em tempo de execução para injetar dependências nas principais famílias de OS do mercado.
* **Varredura Avançada (SYN Stealth Scan):** Análise profunda de todas as 65.535 portas (`-p-`), assinaturas de Sistemas Operacionais (`-O`) e detecção rigorosa de versões de serviços (`-sV`).
* **Auditoria de Vulnerabilidades Integrada:** Acionamento automatizado dos scripts do Nmap (NSE) focados em falhas conhecidas (`vuln`), quebra de credenciais/senhas padrão (`auth`) e checagens regulatórias (`default`).
* **Engine de Relatórios Executivos:** Conversão automática dos logs brutos em XML para uma interface web (HTML) e para um **documento PDF Corporativo** formatado para tomada de decisões.
* **Segurança de Dados Local (Privacy by Design):** Restrição automática de privilégios na pasta de saída (`chmod 700`), garantindo que apenas o usuário `root` possa ler as vulnerabilidades mapeadas.
* **Interface CLI Elegante:** Terminal interativo amigável com um banner exclusivo em arte ASCII, tratamento de interrupções de processos (`Ctrl+C`) e indicador visual de progresso (Spinner).

---

## 🚀 Como Executar

### Pré-requisitos
O **SCANNET** gerencia suas próprias dependências de forma autônoma. Você só precisa garantir acesso à internet no momento da primeira execução para que ele valide e injete o `nmap`, `xsltproc` e `wkhtmltopdf` caso estejam ausentes. No caso do macOS, é necessário ter o `Homebrew` instalado.

### Passo a Passo

1. **Clone o repositório:**
   ```bash
   git clone [https://github.com/gouveialcc/scannet.git)
   cd scannet

Conceda permissão de execução ao script:
$ chmod +x scannet.sh

Execute como ROOT (necessário para pacotes brutos do SYN Scan):
$ sudo ./scannet.sh

Siga as instruções na tela: Digite o IP ou o range da sub-rede alvo (ex: 192.168.1.0/24) quando solicitado.

📊 Estrutura das Evidências Geradas
Após a conclusão, o SCANNET isolará e entregará os seguintes arquivos no mesmo diretório de execução:

scannet_auditoria_AAAA-MM-DD.pdf: Relatório Executivo com propostas de correção e links para patches, ideal para a diretoria.

scannet_auditoria_AAAA-MM-DD.html: Cópia visual para navegadores web.

scannet_auditoria_AAAA-MM-DD.xml: Log estruturado (evidência pura e inviolável para os auditores ISO 27001).

scannet_auditoria_AAAA-MM-DD.nmap: Log textual tradicional da infraestrutura.

☕ Contribua com o Projeto (Donations)
O SCANNET é e sempre será gratuito, aberto e livre de interesses comerciais. Toda a engenharia investida em criar e testar este script em múltiplas arquiteturas e distribuições foi feita de forma voluntária para fortalecer a comunidade global de segurança cibernética.

Manter o código atualizado, testar novas versões de sistemas operacionais e expandir as automações de relatórios exige tempo contínuo de laboratório e dedicação. Se esta ferramenta ajudou sua organização a economizar com licenças caras, otimizou sua rotina técnica ou auxiliou na sua auditoria de conformidade, você pode apoiar voluntariamente a continuidade e manutenção de infraestrutura do projeto através de uma doação.
## 💙 Apoie este Projeto Open Source

Se este software te ajudou, considere fazer uma contribuição para ajudar a manter o desenvolvimento ativo e as atualizações de segurança:

### ⚡ Pix (Brasil)
Use a chave aleatória abaixo no aplicativo do seu banco:
`a850f586-0189-4867-bae3-93830e58dcff`

### ₿ Bitcoin
Envie qualquer valor para o endereço oficial do projeto:
`bc1qr5ka6pjhtkh4rk7k4tgppy3k7svksa2nllr560wrvsjgskz3lm5qxy7f6p`

Toda contribuição é opcional, direcionada integralmente à sustentabilidade técnica da ferramenta e altamente apreciada!
