﻿# TarefaFinalMobile

Como debugar:
Abrir a API
No cmd (No diretorio "uncovering-history-spring") executar docker compose up
Abrir Docker Desktop e abrir o container "api" na terminal
Executar ./mvnw spring-boot:run
Executar a app (Recomendo por USB em dispositivo Android)
Abrir com Visual Studio Code a pasta "turista-app"
Fazer Forward Port no VSCode do porto 8080 com visibilidade pública
Copiar o endereço do devtunnels e reemplazar toda incidencia de o url anterior (nesse caso o do meu pc, IMPORTANTE: que o endereço não finalize com "/")

Executar:
flutter clean
flutter pub get
flutter run
(Isso vai tentar executar no dispositivo configurado, a app foi testada somente em um dispositivo Android via USB)

Se tudo dar certo, a app devería estar rodando.
