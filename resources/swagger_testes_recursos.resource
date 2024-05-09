*** Settings ***
Documentation
Library  RequestsLibrary
Library  String
Library  Collections


*** Variables ***
${TOKEN}   eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2NTMzMGZlZWU3NjA2NGY0NTlkNWYxMGQiLCJmdWxsTmFtZSI6IlFhLUNvZGVycy1TWVNBRE1JTiIsIm1haWwiOiJzeXNhZG1pbkBxYWNvZGVycy5jb20iLCJwYXNzd29yZCI6IiQyYiQxMCRhTXo4NTRBRmpETWtwUWZ6a040alh1Q05rQWpWSEsvRlR5Lll0WmF3M2pHcHpzL1RnbUtpSyIsImFjY2Vzc1Byb2ZpbGUiOiJTWVNBRE1JTiIsImNwZiI6IjExMTExMTExMTExIiwic3RhdHVzIjp0cnVlLCJhdWRpdCI6W3sicmVnaXN0ZXJlZEJ5Ijp7InVzZXJJZCI6IjExMTExMTExMTExMTExMTExMSIsInVzZXJMb2dpbiI6InN5c2FkbWluQHFhY29kZXJzLmNvbSJ9LCJyZWdpc3RyYXRpb25EYXRlIjoic2V4dGEtZmVpcmEsIDIwLzEwLzIwMjMsIDIwOjQwOjMwIEJSVCIsInJlZ2lzdHJhdGlvbk51bWJlciI6IjAxIiwiY29tcGFueUlkIjoiUWEuQ29kZXJzIiwiX2lkIjoiNjUzMzBmZWVlNzYwNjRmNDU5ZDVmMTBlIn1dLCJfX3YiOjAsImlhdCI6MTcxNTIxNDA4NiwiZXhwIjoxNzE1MzAwNDg2fQ.yWuSfSlkR6zhFPdZ8Dd_xftIMcwFXaYvdtlYVxEewOk

*** Keywords ***    
Criar sessão
  ${headers}   Create Dictionary   accept=application/json   Content-Type=application/json    authorization=${TOKEN}
  Create Session   alias=APISwagger   url=https://qualitys-hunters.qacoders-academy.com.br    headers=${headers}    verify=true
  
Criar um novo login de usuário
  ${palavra_randomica}   Generate Random String   length=8   chars=[LETTERS]
  ${palavra_randomica}   Convert To Lower Case   ${palavra_randomica} 
  set test Variable    ${EMAIL_TEST}          ${palavra_randomica}@qacoders.com.br
  Log                  ${EMAIL_TEST}

Cadastrar novo usuário 
  ${body}  Create Dictionary    fullName=Testa do Corre   mail=${EMAIL_TEST}    password=1234@Test    accessProfile=ADMIN  cpf=77224243546    confirmPassword=1234@Test  
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
  Dictionary Should Contain Item    ${RESPOSTA}    msg    Olá Testa do Corre, cadastro realizado com sucesso.   
  Dictionary Should Contain Key    ${RESPOSTA}   user    _id

    

