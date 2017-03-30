import socket

mysocket = socket.socket()
host = socket.gethostbyname(socket.getfqdn())
port = 9876

if host == "127.0.1.1":
    import commands
    host = commands.getoutput("hostname -I")
print "host = " + host

#Prevent socket.error: [Errno 98] Address already in use
mysocket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)

mysocket.bind((host, port))

mysocket.listen(5)

c, addr = mysocket.accept()

while True:

    data = c.recv(1024)
    data = data.replace("\r\n", '') #remove new line character
    #do sth with the data
    inputStr = "Received " + data + " from " + addr[0]
    print inputStr
#    c.send("Hello from Raspberry Pi!\nYou sent: " + data + "\nfrom: " + addr[0] + "\n")

    if data == "Quit": break

c.send("Server stopped\n")
print "Server stopped"
c.close()
