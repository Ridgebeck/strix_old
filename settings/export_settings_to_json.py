import json
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

# Use service account key
cred = credentials.Certificate('serviceAccount.json')
firebase_admin.initialize_app(cred)
db = firestore.client()

# get settings reference
settings_ref = db.collection(u'settings').document(u'mission1')

# get the document from reference
settings_doc = settings_ref.get()

# get data from document as dictionary
settings_dict = settings_doc.to_dict()

# convert dictionary to json and save locally
with open('mission1.json', 'w') as fp:
  json.dump(settings_dict, fp, sort_keys=True, indent=4)

print(settings_doc.to_dict())
