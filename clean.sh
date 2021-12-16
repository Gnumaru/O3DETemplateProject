# apagar o user/log eh de boa, nao tem qualquer efeito
rm -rf user/log
# apagar o 'cache' faz importar de novo os assets, que eh um processo bastante demorado... Alem disso, depois que eu abri a cena inicial o shaderball e o chao sumiram. Entao talvez possa ter outros efeitos colaterais...
rm -rf cache
# apagar o build te obriga a compilar denovo o projeto, senao o editor nao abre. Talvez tenha outros efeitos colaterais
rm -rf build
