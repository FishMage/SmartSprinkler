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


while True:

    c, addr = mysocket.accept()

    data = c.recv(1024)

    data = data.replace("\r\n", '') #remove new line character
    info = data.split() 
    print "Zip: " + info[0] 
    print "Date: " + info[1]
    print "Amount of water: " + info[2] 
    amountOfWater = info[2]
    #Open the file and modify the file
    with open('file.txt','r+') as f:
        f.seek(0) 
        f.write(info[2])
        f.truncate()
        print "File value modified"
    f.close()
       
    #do sth with the data
    inputStr = "Received " + data + " from " + addr[0]
    print inputStr
#    c.send("Hello from Raspberry Pi!\nYou sent: " + data + "\nfrom: " + addr[0] + "\n")
    c.close()
    if data == "Quit": break

c.send("Server stopped\n")
print "Server stopped"
c.close()
