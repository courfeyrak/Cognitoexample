import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'amplifyconfiguration.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  initState() {
    super.initState();
    _configureAmplify();
  }
  Future<void> _configureAmplify() async {

    // Add any Amplify plugins you want to use
    final authPlugin = AmplifyAuthCognito();
    await Amplify.addPlugin(authPlugin);

    // You can use addPlugins if you are going to be adding multiple plugins
    // await Amplify.addPlugins([authPlugin, analyticsPlugin]);

    // Once Plugins are added, configure Amplify
    // Note: Amplify can only be configured once.
    try {
      await Amplify.configure(amplifyconfig);
    } on AmplifyAlreadyConfiguredException {
      print("Tried to reconfigure Amplify; this can occur when your app restarts on Android.");
    }
  }
  
  bool isSignUpComplete = false;
  Future<void> signUpUser() async {
    try {
      final userAttributes = <CognitoUserAttributeKey, String>{
        CognitoUserAttributeKey.email: 'carlos.gtz.cg@gmail.com',
        CognitoUserAttributeKey.phoneNumber: '+5583078050',
        // additional attributes as needed
      };
      final result = await Amplify.Auth.signUp(
        username: 'carlos.gtz.cg@gmail.com',
        password: 'Hgijrt893417#',
        options: CognitoSignUpOptions(userAttributes: userAttributes),
      );
      setState(() {
        isSignUpComplete = result.isSignUpComplete;
      });
    } on AuthException catch (e) {
      print(e.message);
    }
  }
  Future<void> confirmUser() async {
    try {
      final result = await Amplify.Auth.confirmSignUp(
          username: 'carlos.gtz.cg@gmail.com', confirmationCode: '995615');
      setState(() {
        isSignUpComplete = result.isSignUpComplete;
      });
    } on AuthException catch (e) {
      print(e.message);
    }
  }
  Future<void> confirmSignInPhoneVerification(String otpCode) async {
  await Amplify.Auth.confirmSignIn(
      confirmationValue: otpCode,
  );
}
// Create a boolean for checking the sign in status
  bool isSignedIn = false;
  Future<void> signInUser(String username, String password) async {
  try {
    final result = await Amplify.Auth.signIn(
      username: username,
      password: password,
    );

    setState(() {
      isSignedIn = result.isSignedIn;
    });
    print("->>> "+ result.isSignedIn.toString());
    fetchAuthSession();
  } on AuthException catch (e) {
    print("error " + e.message);
    fetchAuthSession();
  }
}
  Future<void> confirmSignUpPhoneVerification(String username, String password) async {
    try {
      final result = await Amplify.Auth.signIn(
        username: username,
        password: password,
      );
      print('Resultado');
      print((result as SignInResult).isSignedIn);
      
      setState(() {
        isSignedIn = result.isSignedIn;
      });
    } on AuthException catch (e) {
      print('Hubo un error wntrando');
      print(e.message);
    }
  }
  Future<void> fetchAuthSession() async {
    try {
      final result = await Amplify.Auth.fetchAuthSession(
        options: CognitoSessionOptions(getAWSCredentials: true),
      );
      print((result as CognitoAuthSession).userPoolTokens?.accessToken);
      print("idtoken:");
      print((result as CognitoAuthSession).userPoolTokens?.idToken);
      
    } on AuthException catch (e) {
      print(e.message);
    }
  }
  Future<void> signOutCurrentUser() async {
  try {
    await Amplify.Auth.signOut();
  } on AuthException catch (e) {
    print(e.message);
  }
}
  void printWrapped(String text) {
    final pattern = new RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }
  
  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    
  return MaterialApp(
      home: Scaffold(
          body: Center(
              child: Column(
        children: [
          TextButton(
            onPressed: () async => {signUpUser()},
            child: Text('TextButton'),
          ),
          TextButton(
            onPressed: () async =>
                {signInUser('carlos.gtz.cg@gmail.com', 'Hgijrt893417#')},
            child: Text('Sign in'),
          ),
          TextButton(
            onPressed: () async => {confirmUser()},
            child: Text('Confirm sign up'),
          ),  
          TextButton(
            onPressed: () async => {confirmSignInPhoneVerification('667520')},
            child: Text('Confirm sign in'),
          ),  
          TextButton(
            onPressed: () async => {signOutCurrentUser()},
            child: Text('Sign out'),
          ), 
          TextButton(
            onPressed: () async => {confirmSignUpPhoneVerification('carlos.gtz.cg@gmail.com', 'Hgijrt893417#')},
            child: Text('Sign in with mfa'),
          ),
        ],
      ))),
    );

  }
}
