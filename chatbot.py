#-*- coding: utf-8 -*-

from chatterbot.trainers import ListTrainers
from chatterbot import ChatBot 
import os

chatBot = ChatBot('Hello World')

for arq in os.listdir('arqs'):
    chat = open('arqs/' + arq, 'r').readlines()
    chatBot.train(chat)

while True:
    resq = input('Você: ')
    resp = bot.get_response(resp);
    print('ChatBot: '+ resp)
    


