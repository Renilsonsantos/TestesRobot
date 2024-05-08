*** Settings ***
Documentation
Library  RequestsLibrary
Library  String
Library  Collections

*** Variables ***

${TOKEN}   eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2NTMzMDk5YWZhNzBkNTMwNzVjODFlZjQiLCJmdWxsTmFtZSI6IlFhLUNvZGVycy1TWVNBRE1JTiIsIm1haWwiOiJzeXNhZG1pbkBxYWNvZGVycy5jb20iLCJwYXNzd29yZCI6IiQyYiQxMCRBVEd0US5ZMVB4a1VxNHJDS00zS2x1djl4TVJIUHU4Mkg4Ylo3ZFNFSVNxTHVQSlIuTEFuNiIsImFjY2Vzc1Byb2ZpbGUiOiJTWVNBRE1JTiIsImNwZiI6IjExMTExMTExMTExIiwic3RhdHVzIjp0cnVlLCJhdWRpdCI6W3sicmVnaXN0ZXJlZEJ5Ijp7InVzZXJJZCI6IjExMTExMTExMTExMTExMTExMSIsInVzZXJMb2dpbiI6InN5c2FkbWluQHFhY29kZXJzLmNvbSJ9LCJyZWdpc3RyYXRpb25EYXRlIjoic2V4dGEtZmVpcmEsIDIwLzEwLzIwMjMsIDIwOjEzOjI5IEJSVCIsInJlZ2lzdHJhdGlvbk51bWJlciI6IjAxIiwiY29tcGFueUlkIjoiUWEuQ29kZXJzIiwiX2lkIjoiNjUzMzA5OWFmYTcwZDUzMDc1YzgxZWY1In1dLCJfX3YiOjAsImlhdCI6MTcxNTA0MTQ2NiwiZXhwIjoxNzE1MTI3ODY2fQ.-IjitM51kx2LkafPmGSL7761Mxho_oGVpza9cSQiTiw

*** Keywords ***
Criar sessão
  ${headers}   Create Dictionary   accept=application/json   Content-Type=application/json    authorization=${TOKEN}
  Create Session   alias=APISwagger   url=https://qualitys-hunters.qacoders-academy.com.br   headers=${headers}
    
Massa de dados diretoria
  ${palavra_randomica_diretoria}   Generate Random String   length=8   chars=[LETTERS]
  ${palavra_randomica_diretoria}   Convert To Lower Case   ${palavra_randomica_diretoria} 
  set test Variable    ${BOARD_NAME}          ${palavra_randomica_diretoria}
  Log                  ${BOARD_NAME}

incluir nova diretoria 
  ${headers}   Create Dictionary        authorization=${TOKEN}
  ${body}   Create Dictionary           boardName=${BOARD_NAME}  
  Log    ${body}
  Criar sessão
  ${resposta}  POST On Session    alias=APISwagger    url=/api/board/    json=${body} 
  Log     ${resposta.json()}
  Set Test Variable    ${BOARD_NAME}    ${resposta.json()['newBoard']['_id']}
  Set Test Variable    ${RESPOSTA}    ${resposta.json()}


Validar campo obrigatório vazio a mensagem O campo boardName é obrigatório
  ${headers}   Create Dictionary        authorization=${TOKEN}
  ${body}   Create Dictionary           boardName=""
  Log To Console   ${body}
  Criar sessão
  ${resposta}  POST On Session    alias=APISwagger    url=/api/board    json=${body}   
  Log   ${resposta.json()}
  Set Test Variable    ${BOARD_NAME}    ${resposta.json()['newBoard']['_id']}  
  Set Test Variable    ${RESPOSTA}    ${resposta.json()}

validar campo preenchido com caracteres não permitidos "O campo boardName só pode conter (descrição_caracteres)
  ${headers}   Create Dictionary        authorization=${TOKEN}
  ${body}   Create Dictionary           boardName="#"
  Log    ${body}
  Criar sessão
  ${resposta}  POST On Session    alias=APISwagger    url=/api/board/    json=${body}   
  Log    ${resposta.json()}
  Set Test Variable    ${BOARD_NAME}    ${resposta.json()['newBoard']['_id']}  
  Set Test Variable    ${RESPOSTA}    ${resposta.json()}

deve permitir somente letras maiúsculas, minúsculas e o caractere especial & 
  ${headers}   Create Dictionary        authorization=${TOKEN}
  ${body}   Create Dictionary    boardName=EiQe&
  Log    ${body}
  Criar sessão
  ${resposta}  POST On Session    alias=APISwagger    url=/api/board/    json=${body}   expected_status=201
  Log    ${resposta.json()}
  Set Test Variable    ${BOARD_NAME}    ${resposta.json()['newBoard']['_id']}  
  Set Test Variable    ${RESPOSTA}    ${resposta.json()}

