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
  Create Session   alias=APISwagger   url=https://qualitys-hunters.qacoders-academy.com.br    headers=${headers}
  
Criar um novo login de usuário
  ${palavra_randomica}   Generate Random String   length=8   chars=[LETTERS]
  ${palavra_randomica}   Convert To Lower Case   ${palavra_randomica} 
  set test Variable    ${EMAIL_TEST}          ${palavra_randomica}@qacoders.com.br
  Log                  ${EMAIL_TEST}

Cadastrar novo usuário 
  ${body}  Create Dictionary    fullName=Testa do Cort    mail=${EMAIL_TEST}    password=1234@Test    accessProfile=ADMIN  cpf=88223243531    confirmPassword=1234@Test  
  Log    ${body}
  Criar sessão
      ${resposta}    POST On Session    alias=APISwagger    url=/api/user    json=${body}  expected_status=201   
  Log To Console    ${resposta.json()}
  Set Test Variable    ${ID_USUARIO}    ${resposta.json()["user"]["_id"]}
  Set Test Variable    ${RESPOSTA}    ${resposta.json()}

Consultar os dados do usuário
  ${resposta_consultar}    GET On Session    alias=APISwagger    url=/api/user/${ID_USUARIO}    expected_status=200
  Set Test Variable    ${RESPOSTA_CONSULTAR}                        ${resposta_consultar.json()}

Conferir se este novo ususário foi cadastrado corretamente
  Log    ${RESPOSTA}
  Dictionary Should Contain Item    ${RESPOSTA}    msg    Olá Testa do Cort, cadastro realizado com sucesso.   
  Dictionary Should Contain Key    ${RESPOSTA}   user    _id

    

