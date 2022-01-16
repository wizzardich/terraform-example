import os
import time
from random import random

from flask import Flask, request

app = Flask(__name__)

@app.route('/hello')
def hello_world():
    """
    Public endpoint that greets the world.
    """
    return 'Hello World from Flask!'

@app.route('/health')
def health():
    """
    Internal endpoint for health check.
    """
    return 'OK' if os.environ.get('HEALTH_TOKEN') == 'foo' else 'KO'

@app.route('/fib')
def fib_handler():
    """
    Internal endpoint for fibonacchi calculation without anylimit.
    """
    n = request.args.get('n')
    return str(fib(int(n)))

@app.route('/load')
def load_handler():
    """
    Internal endpoint for fibonacchi calculation without anylimit.
    """
    return generate_cpu_load()

def generate_cpu_load():
    """
    Gloriously uselss load generation
    """
    for i in range(20000):
        i*i
    return "Done!"

def fib(n):
    """
    Gloriously inefficient fibonacci function
    """
    if random() < 0.1:
        unfortunate_course_of_events()

    if n<0: 
        raise ValueError("Incorrect input") 
    elif n==0: 
        return 0
    elif n==1: 
        return 1
    else: 
        return fib(n-1)+fib(n-2) 

def unfortunate_course_of_events():
    print("Something very unfortunate happened. I'm going to hang forever.")
    while True:
        time.sleep(10)

if __name__ == '__main__':
    app.run()

