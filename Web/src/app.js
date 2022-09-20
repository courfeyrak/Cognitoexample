import Amplify, { Auth } from 'aws-amplify';
import awsconfig from './aws-exports';
Amplify.configure(awsconfig);

async function confirmSignUp() {
    var username="carlos.gtz.cg@gmail.com"; //<- se confirma con el username
    var code="509081";
    try {
      await Auth.confirmSignUp(username, code);
    } catch (error) {
        console.log('error confirming sign up', error);
    }
}

async function signIn() {
    try {
        var username="carlos.gtz.cg@gmail.com";
        var password="Hgijrt89$";
        const user = await Auth.signIn(username, password);
        console.log(user);
    } catch (error) {
        console.log('error signing in', error);
    }
}

async function signInGoogle() {
    try {
        
        const user=await Auth.federatedSignIn({provider: 'Google'}).
        then(cred => {
          // If success, you will get the AWS credentials
          localStorage.setItem('cred',JSON.stringify(cred));
          
          return Auth.currentAuthenticatedUser();
        });
        localStorage.setItem('user',JSON.stringify(user));
        console.log(user);
    } catch (error) {
        console.log('error signing in', error);
    }
}

async function signUp() {
    try {
        var username="carlos.gtz.cg@gmail.com"; // mismo que el mail el username
        var password="H2dfasdf$";
        var email="carlos.gtz.cg@gmail.com";
        var phone_number="";
        var name="Carlos"
        var middle_name="Alberto"
        var family_name="gutierrez";
        
        const { user } = await Auth.signUp({
            username,  //usar el mismo mail como user
            password,
            attributes: {
                email,          // optional
                phone_number,   // optional - E.164 number convention
                name,
                family_name,// other custom attributes 
                middle_name
            }
        });
        console.log(user);
    } catch (error) {
        console.log('error signing up:', error);
    }
}

const MutationButton = document.getElementById("MutationEventButton");
const adduserButton = document.getElementById("addUserEventButton");
const Logingooglebt = document.getElementById("Logingooglebt");
const confirm = document.getElementById("confirm");


confirm.addEventListener("click", (evt) => {
    confirmSignUp().then((evt) => {
      
    });
  });

Logingooglebt.addEventListener("click", (evt) => {
    signInGoogle().then((evt) => {
      MutationResult.innerHTML += `<p>${evt.data.createTodo.name} - ${evt.data.createTodo.description}</p>`;
    });
  });

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