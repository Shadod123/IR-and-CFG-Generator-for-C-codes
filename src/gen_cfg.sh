#---------------------------------------------------------------------------------------------------------------
# Autor:      Caio Eduardo Ramos Arães
# Matrícula:  738811
# Disciplina: Compiladores (2024/1)
# Professor:  Pedro Henrique Ramos Costa
# Data:       19/05/2024
# Descrição:  Script para geração de CFGs de um programa C
#
# OBS: O script foi testado em um ambiente Linux (Ubuntu 22.04) via WSL2
#
# Instruções: Basta executar o script passando como argumento o caminho para o arquivo C (a partir da pasta src)
#             que todos os CFGs serão gerados de uma vez e salvos na própria pasta do programa.
#
# Exemplo:    ./gen_cfg.sh fact/fact.c
#---------------------------------------------------------------------------------------------------------------

# Indica que o interpretador de comandos a ser utilizado é o bash (descomentar, se necessário)
#!/bin/bash 

# Verifica se o programa C foi fornecido como argumento
if [ $# -lt 1 ]; then
    echo "Uso: $0 <dir/programa.c>"
    exit 1
fi

# Nome do arquivo C fornecido
FILE=$1

# Diretório onde o programa está localizado
DIR=$(dirname "$FILE")

# Nome base do arquivo (sem extensão)
BASENAME=$(basename "$FILE" .c)

# Função para gerar os CFGs
generate_cfg() {
    local optimization_level=$1
    local ir_file="${BASENAME}_O${optimization_level}.ll"
    local modified_ir_file="${BASENAME}_O${optimization_level}_mod.ll"
    local output_dir="${DIR}/O${optimization_level}"

    # Cria o diretório para armazenamento dos arquivos .ll, .dot e .png gerados
    mkdir -p "$output_dir"

    # Gera a representação intermediária (IR) do código
    clang -S -emit-llvm -O${optimization_level} -fno-discard-value-names "$DIR/$BASENAME.c" -o "${output_dir}/$ir_file"

    # Remove as diretivas optnone do arquivo de IR   
    sed 's/optnone//g' "${output_dir}/$ir_file" > "${output_dir}/$modified_ir_file"

    # Muda para o diretório de saída
    pushd "$output_dir" > /dev/null

    # Gera os arquivos .dot
    opt -dot-cfg "$modified_ir_file" > /dev/null 2>&1

    # Verifica se existem arquivos .dot no diretório de saída
    if ls .*.dot 1> /dev/null 2>&1; then
        # Converte cada arquivo .dot existente em uma imagem PNG via Graphviz
        for dot_file in .*.dot; do
            function_name=$(basename "$dot_file" .dot)
            output_png="${BASENAME}.O${optimization_level}${function_name}.png"
            dot -Tpng "$dot_file" -o "$output_png"
            # Remove os arquivos .dot, se assim desejado
            rm "$dot_file"
        done
    else
        echo "Nenhum arquivo .dot encontrado em $output_dir"
    fi

    # Remove os arquivos de IR, se assim desejado
    #rm "$ir_file" "$modified_ir_file"

    # Volta ao diretório anterior (src)
    popd > /dev/null
    
    echo "Grafos de Fluxo de Controle gerados para O${optimization_level} em ${output_dir}/"
}

# Gera os CFGs para os níveis de otimização O0, O1, O2 e O3
generate_cfg 0
generate_cfg 1
generate_cfg 2
generate_cfg 3
