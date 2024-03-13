import pymongo
import json

# Create MongoDB client, open connection to Annie's Amazon DocumentDB instance
client = pymongo.MongoClient('mongodb://docdbmaster:GBS$msba$2024@msba2024-production-instance-cluster.cluster-cqxikovybdnm.us-east-2.docdb.amazonaws.com:27017/?replicaSet=rs0&readPreference=secondaryPreferred&retryWrites=false')

# Create strings to store my specific database and collection
netid = 'dmosden'
mydatabase = netid + "_database"
mycollection = netid + "_collection"

# Use string to connect to my database
db = client[mydatabase]

# Use string to connect to my collection
col = db[mycollection]

# Load data from the JSON file 
with open('/home/ubuntu/json_laureates.json', 'r') as file:
    data = json.load(file)

# Insert data into the collection (wow this was easy)
col.insert_many(data)

# Close the connection
client.close()