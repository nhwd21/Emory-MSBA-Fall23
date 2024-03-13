import pymongo

# Create a MongoDB client, open a connection to Annie's Amazon DocumentDB instance
client = pymongo.MongoClient('mongodb://docdbmaster:GBS$msba$2024@msba2024-production-instance-cluster.cluster-cqxikovybdnm.us-east-2.docdb.amazonaws.com:27017/?replicaSet=rs0&readPreference=secondaryPreferred&retryWrites=false')

# Create strings to store the path for my db and collection
netid = 'dmosden'
mydatabase = netid + "_database"
mycollection = netid + "_collection"

# connect to my db and collection
db = client[mydatabase]
col = db[mycollection]

# Query to show all awards given out in a selected year for specific categories
def query_awards_by_year(year):
    results = col.find({"nobelPrizes.awardYear": year}) # finds the instances where awardYear = year (in our case 2009)
    for result in results: # loop through every result saved
        for prize in result['nobelPrizes']: # loop through each prize
            if prize['awardYear'] == year: # only if the prize award year was 2009... (basically a Python-powered double-check that we are looking at the right data)
                print(f"In the Year {year}, Nobel award for {prize['category']['en']} was given to {result['fullName']['en']}") # then use fstring to print the string with relevant data as required by the assignment

# Query to show all award winners in a specific category for specific years
def query_awards_by_category(category):
    results = col.find({"nobelPrizes.category.en": category}) # finds the instance where category.en = category (in our case Physics)
    for result in results: # loop through every result saved
        for prize in result['nobelPrizes']: # loop through every prize 
            if prize['category']['en'] == category: # again, just double check that we're looking at the right data before we print it
                print(f"In the Year {prize['awardYear']}, Nobel award for {category} was given to {result['fullName']['en']}") # print an fstring with all of the data the assignment asked for

# Get the 2009 award winners
print("2009 Winners:")
years_2009 = ["2009"]
query_awards_by_year("2009")

# Get the physics award winners
print("\nPhysics Winners:")
query_awards_by_category("Physics")


# Close the connection
client.close()