import 'package:animation_login_page/animation_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Artboard? riveArtBoard;

  late RiveAnimationController idleController;

  late RiveAnimationController handsUpController;

  late RiveAnimationController handsDownController;

  late RiveAnimationController successController;

  late RiveAnimationController failController;

  late RiveAnimationController lookDownRightController;

  late RiveAnimationController lookDownLeftController;

  late RiveAnimationController lookIdleController;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String testEmail = 'midoredase@gmail.com';
  String testPassword = '1234567';

  final passWordFocusNode = FocusNode();

  bool isLookingLeft = false;

  bool isLookingRight = false;

  void removeAllController() {
    riveArtBoard?.artboard.removeController(idleController);
    riveArtBoard?.artboard.removeController(handsUpController);
    riveArtBoard?.artboard.removeController(handsDownController);
    riveArtBoard?.artboard.removeController(lookDownLeftController);
    riveArtBoard?.artboard.removeController(lookDownRightController);
    riveArtBoard?.artboard.removeController(successController);
    riveArtBoard?.artboard.removeController(failController);
    riveArtBoard?.artboard.removeController(lookIdleController);
    isLookingLeft = false;
    isLookingRight = false;
  }

  void addIdleController() {
    removeAllController();
    riveArtBoard?.artboard.addController(idleController);
    debugPrint('idlee');
  }

  void addHandsUpController() {
    removeAllController();
    riveArtBoard?.artboard.addController(handsUpController);
    debugPrint('hands up');
  }

  void addHandsDownController() {
    removeAllController();
    riveArtBoard?.artboard.addController(handsDownController);
    debugPrint('hands down');
  }

  void addLookDownRightController() {
    removeAllController();
    isLookingRight = true;
    riveArtBoard?.artboard.addController(lookDownRightController);
    debugPrint('look down right');
  }

  void addLookDownLeftController() {
    removeAllController();
    isLookingLeft = true;
    riveArtBoard?.artboard.addController(lookDownLeftController);
    debugPrint('look down left');
  }

  void addSuccessController() {
    removeAllController();
    riveArtBoard?.artboard.addController(successController);
    debugPrint('success');
  }

  void addFailController() {
    removeAllController();
    riveArtBoard?.artboard.addController(failController);
    debugPrint('fail');
  }

  void addLookIdleController() {
    removeAllController();
    riveArtBoard?.artboard.addController(lookIdleController);
    debugPrint('look idle');
  }

  void checkForPasswordFocusNodeToChangeAnimationState() {
    passWordFocusNode.addListener(() {
      if (passWordFocusNode.hasFocus) {
        addHandsUpController();
      } else if (!passWordFocusNode.hasFocus) {
        addHandsDownController();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    idleController = SimpleAnimation(AnimationEnum.idle.name);
    handsUpController = SimpleAnimation(AnimationEnum.Hands_up.name);
    handsDownController = SimpleAnimation(AnimationEnum.hands_down.name);
    successController = SimpleAnimation(AnimationEnum.success.name);
    failController = SimpleAnimation(AnimationEnum.fail.name);
    lookDownRightController =
        SimpleAnimation(AnimationEnum.Look_down_right.name);
    lookDownLeftController = SimpleAnimation(AnimationEnum.Look_down_left.name);
    lookIdleController = SimpleAnimation(AnimationEnum.look_idle.name);

    rootBundle.load('assets/login_animation.riv').then((data) {
      final file = RiveFile.import(data);
      final artBoard = file.mainArtboard;
      artBoard.addController(idleController);
      setState(() {
        riveArtBoard = artBoard;
      });
    });

    checkForPasswordFocusNodeToChangeAnimationState();
  }

  void validateEmailAndPassword() {
    Future.delayed(const Duration(seconds: 1), () {
      if (formKey.currentState!.validate()) {
        addSuccessController();
      } else {
        addFailController();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Animated Login'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 20),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 3,
                child: riveArtBoard == null
                    ? const SizedBox.shrink()
                    : Rive(
                        artboard: riveArtBoard!,
                      ),
              ),
              Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        validator: (value) =>
                            value != testEmail ? 'Wrong Email' : null,
                        onChanged: (value) {
                          if (value.isNotEmpty &&
                              value.length < 14 &&
                              !isLookingLeft) {
                            addLookDownLeftController();
                          } else if (value.isNotEmpty &&
                              value.length > 14 &&
                              !isLookingRight) {
                            addLookDownRightController();
                          }
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 25,
                      ),
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        validator: (value) =>
                            value != testPassword ? 'Wrong Password' : null,
                        focusNode: passWordFocusNode,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 18,
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width / 8),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            shape: const StadiumBorder(),
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () {
                            passWordFocusNode.unfocus();
                            validateEmailAndPassword();
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
