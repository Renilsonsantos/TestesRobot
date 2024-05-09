*** Settings ***
Resource  ../resources/swagger_testes_recursos.resource
Resource  ../resources/diretoria_swagger_testes_recursos.resource

*** Variables ***

*** Test Cases ***
Cenário com POST: Cadastrar um novo ususário com sucesso
    Criar um novo login de usuário
    Cadastrar novo usuário
    Consultar os dados do usuário
    Conferir se este novo ususário foi cadastrado corretamente

Cenário com POST: Cadastrar diretoria 
    incluir nova diretoria  
   # validar campo obrigatório vazio a mensagem O campo boardName é obrigatório
   #validar campo preenchido com caracteres não permitidos "O campo boardName só pode conter (descrição_caracteres)
    deve permitir somente letras maiúsculas, minúsculas e o caractere especial & 
    