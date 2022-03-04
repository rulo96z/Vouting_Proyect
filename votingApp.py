



###### Still needs a lot of work. Just putting together a littl bit of an outline. Feel free to edit #######



import os
import json
from web3 import Web3
from pathlib import Path
from dotenv import load_dotenv
import streamlit as st

load_dotenv()

# Define and connect a new Web3 provider
w3 = Web3(Web3.HTTPProvider(os.getenv("WEB3_PROVIDER_URI")))


### Loads the contract once using cache
### Connects to the contract using the contract address and ABI


# Cache the contract on load
@st.cache(allow_output_mutation=True)

# Define the load_contract function
def load_contract():

    # Load Voting ABI
    with open(Path('contracts/compiled/votingApp_abi.json')) as f:
        voting_abi = json.load(f)

    # Set the contract address (this is the address of the deployed contract)
    contract_address = os.getenv("SMART_CONTRACT_ADDRESS")

    # Get the contract
    contract = w3.eth.contract(
    address = w3.toChecksumAddress(contract_address),
    abi = voting_abi)

    # Return the contract from the function
    return contract
contract = load_contract()
#Streamlit Title
st.title('Decentralized Voting Application')
st.image("https://github.com/rulo96z/Vouting_Proyect/blob/master/image/Eii7lfJWAAEQJ-n.png?raw=True")

voter_adddress = st.text_input("Voter Address")
voter_name = st.text_input("Voter Name")
voter_age = st.text_input("Voter Age")
form = (f"{voter_adddress}{voter_name}{voter_age}")
if st.button("Submit"):
    contract.functions.registerVoter(form).transact({'from': voter_adddress, 'gas': 1000000})
    st.write("Congratulations! You are Registered to Vote!")
    st.balloons()

st.empty()
st.title("Vote For Your Candidate")
# # chocolate_wallet_address = os.getenv("CHOCOLATE_WALLET")
# # vanilla_wallet_address = os.getenv("VANILLA_WALLET")
# # strawberry_wallet_address = os.getenv("STRAWBERRY_WALLET")
# Candidate1 = ["Chocolate", chocolate]#_wallet_address]
# Candidate2 = ["Vanilla", vanilla]#_wallet_address]
# Candidate3 = ["Strawberry", strawberry]#_wallet_address]
# candidate_vote = st.radio("Choose Your Candidate",
#     ([Candidate1[0],
#     Candidate2[0],
#     Candidate3[0]]))
# if st.button("Submit Your Vote!"):
#     contract.functions.vote(candidate_vote)
# if candidate_vote == Candidate1:
#     contract.functions.vote(candidate_vote)
# if candidate_vote == Candidate2:
#     contract.functions.vote(candidate_vote)
# if candidate_vote == Candidate3:
#     contract.functions.vote(candidate_vote)
