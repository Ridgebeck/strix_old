import json
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

# Use service account key
cred = credentials.Certificate('serviceAccount.json')
firebase_admin.initialize_app(cred)
db = firestore.client()


# read json settings file and save locally
with open('mission1.json', 'r') as fp:
    data = json.load(fp)

# write data to firestore
doc_ref = db.collection(u'settings').document(u'mission1')
doc_ref.set(data)

print('settings document uploaded to Firestore')
