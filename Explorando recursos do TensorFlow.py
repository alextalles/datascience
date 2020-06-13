#!/usr/bin/env python
# coding: utf-8

# Introdução ao Tensorflow:
# 
# - Conceitos: Tensor é um escalar "5", um vetor [1, 2, 3], uma matriz bidimensional [1, 2, 3][4, 5, 6], uma matriz tridimensional (ou com maiores dimensões). Flow é um fluxo, portanto temos o TensorFlow que é simplesmente um fluxo de tensores   (inputs, operation add e output).
# - Função matemática do TensorFlow:  f(x, y) = x2y + y + 2, utilizada um grafo.
# - TensorFlow trabalha com estrutura de grafos e com computação paralela. Se utilizar o TensorFlow com Rede Neural, temos um desempenho muito alto de processamento (GPUs).
# - Biblioteca de código aberta para computação númerica.
# - Aplicações: Sistema de Tradução, Diagnóstico de Diabetes, Carros Autônomos, Descoberta de cura para Doenças e dentre outras.
# - Utiliza XLA (Accelerated Linear Algebra), CPU, GPU e TPU para acelerar os modelos de ML.
# - Pode ser utilizado para desenvolvimento Front-End em Java, C++, GO e outras linguaguens. 

# In[30]:


import tensorflow as tf


# In[31]:


# Trabalhando com Constantes ...


# In[32]:


# Trabalhando com valores inteiros ...
valor1 = tf.constant(2)
valor2 = tf.constant(3)


# In[33]:


type(valor1)


# In[34]:


# Tensor: Classe
# const_2: Nome da Constante
# shape: Tamanho/Formato está vazio porque é um número escalar. 
# dtype: Tipo de Dado


# In[38]:


# Criando apenas uma fórmula, pois neste momento não é possível executar o cálculo da soma, porque precisa criar uma Session para executar.
soma = valor1 + valor2
print(soma)


# In[36]:


type(soma)


# In[39]:


# Criando uma Sesssion para executar o cálculo da soma ...
with tf.Session() as sess:
    # Serve para executar a operação 
    s = sess.run(soma)
    print(s)


# In[40]:


# Trabalhando com valores strings ...
texto1 = tf.constant('Texto 1')
texto2 = tf.constant('Texto 2')


# In[41]:


type(texto1)


# In[42]:


print(texto1)


# In[43]:


# Observa-se que temos agora a "Const_4" incrementada, porque antes existia a Const_2.


# In[44]:


with tf.Session() as sess:
    # Serve para executar a operação.
    concatenate = sess.run(texto1 + texto2)
    print(concatenate)


# In[45]:


type(concatenate)


# In[46]:


# Fazendo a manipulação de Variáveis ...


# In[47]:


x = 35
y = x + 35


# In[48]:


print(y)


# In[49]:


valor1 = tf.constant(15, name = "valor1")


# In[50]:


print(valor1)


# In[56]:


# Executa apenas o Grafo, mas não executa o cálculo da soma.
soma = tf.Variable(valor1 + 5, name = "valor1")
print(soma)


# In[53]:


type(soma)


# In[54]:


# Inicializando as Variáveis, cria-se um Grafo com as dependências entre as variáveis, ou seja, a variável "soma" que foi definida
# depende da constante "valor1" e o valor é computado quando executa o cálculo.
init = tf.global_variables_initializer()


# In[55]:


# Criando uma Sessão para executar o cálculo e imprimir o resultado.
with tf.Session() as sess:
    sess.run(init)
    s = sess.run(soma)
    print(s)


# Trabalhando com Vetor ...

# In[79]:


vetor = tf.constant([5, 10, 15], name = "vetor")
print(vetor)


# In[80]:


# shape: define os valores do vetor (5, 10, 15).


# In[81]:


soma = tf.Variable(vetor + 5, name = "soma")
print(soma)


# In[82]:


init = tf.global_variables_initializer()


# In[83]:


with tf.Session() as sess:
    sess.run(init)
    s = sess.run(soma)
    print(s)


# In[84]:


valor = tf.Variable(0, name = "valor")


# In[85]:


init2 = tf.global_variables_initializer()


# In[86]:


with tf.Session() as sess:
    sess.run(init2)
    for i in range(5):
        valor = valor + 1
        print(sess.run(valor))

