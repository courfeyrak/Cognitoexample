import Amplify, { Auth } from 'aws-amplify';
import awsconfig from './aws-exports';
Amplify.configure(awsconfig);


async function signIn() {
    try {
        var username="carlos";
        var password="Hgijrt89$";
        const user = await Auth.signIn(username, password);
        console.log(user);
    } catch (error) {
        console.log('error signing in', error);
    }
}

async function signUp() {
    try {
        var username="carlos";
        var password="Hgijrt89$";
        var email="carlos.gtz.cg@gmail.com";
        var phone_number="";
        const { user } = await Auth.signUp({
            username,
            password,
            attributes: {
                email,          // optional
                phone_number,   // optional - E.164 number convention
                // other custom attributes 
            }
        });
        console.log(user);
    } catch (error) {
        console.log('error signing up:', error);
    }
}

const MutationButton = document.getElementById("MutationEventButton");
const adduserButton = document.getElementById("addUserEventButton");


MutationButton.addEventListener("click", (evt) => {
    signIn().then((evt) => {
      MutationResult.innerHTML += `<p>${evt.data.createTodo.name} - ${evt.data.createTodo.description}</p>`;
    });
  });

  adduserButton.addEventListener("click", (evt) => {
    signUp().then((evt) => {
      MutationResult.innerHTML += `<p>${evt.data.createTodo.name} - ${evt.data.createTodo.description}</p>`;
    });
  });