# Smart contract desenvolvido em Vyper - Luis Filipe Loureiro

# Mapeia endereco-> valor_doado (inicializado como zero)
users: public(HashMap[address, uint256])

# valor da meta
meta: uint256

# contador do total arrecadado
contador: uint256

# Data Limite do crowdfunding
tempolimite: uint256

# Dono do contrato
owner: address

### Funcoes ###

# Inicializacao do contrato
@external
def __init__(meta: uint256, tempolimite: uint256):
    # Data limite ja foi ultrapassada?
    assert block.timestamp < tempolimite
    
    self.owner = msg.sender
    self.meta = meta
    self.tempolimite = tempolimite
    self.contador = 0


# Finalizando o contrato
# Função para que o dono encerre a vaquinha
@external
def finish():
  # Apenas o dono pode encerrar, apos o deadline e se superou (ou igualou) a meta
  assert msg.sender == self.owner
  assert block.timestamp >= self.tempolimite
  assert self.contador >= self.meta
  #dono recebe todo o dinheiro captado no crowdfunding
  send(msg.sender, self.contador)


# Doando para o crowdfunding
@external
@payable
def donate():
    # Ainda esta no prazo?
    assert block.timestamp < self.tempolimite
    # Atualizando hashmap
    self.users[msg.sender] += msg.value
    # Atualizando a balanca
    self.contador += msg.value

# Retornando dinheiro aos doadores
@external
def recall():    
    # Requisito 0: ter passado do prazo
    assert block.timestamp > self.tempolimite
    # Requisito 1: valor nao ter passado da meta
    assert self.contador < self.meta
    # Solicitante tem algo a receber?
    assert self.users[msg.sender] > 0  
    

    # Cumprindo os requisitos; ocorre o extorno
    send(msg.sender, self.users[msg.sender])
    # Atualizando o hashmap
    self.users[msg.sender] = 0
    



