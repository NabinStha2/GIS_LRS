const { generateOTP } = require("../utils/generateOTP");
const { sendEmailToEmailAddress } = require("../utils/mail");
const { SetErrorResponse } = require("../utils/responseSetter");
const { setCacheOTP, getCacheOTP } = require("../cache/cacheOTP");
const User = require("../models/user.model");
const { customSecretKey } = require("../utils/customSecretKey");
const jwt = require("jsonwebtoken");
const { userDataPipelining } = require("../utils/userDataPipelining");

exports.userRegisterController = async (req, res, next) => {
  try {
    const { email, firstName, lastName, phoneNumber, address, password } =
      req.body;

    const existingUser = await User.findOne({
      email: email,
    });
    if (existingUser) {
      throw new SetErrorResponse("Already registerd with this account.", 500);
    }
    const otp = generateOTP();

    const savingValues = {
      email,
      firstName,
      lastName,
      phoneNumber,
      address,
      password,
      otp,
    };
    setCacheOTP({ email, prefix: "register", savingValues });

    const sendEmail = await sendEmailToEmailAddress({
      email,
      otp,
      subject:
        "Welcome From A GIS based land registration system! Thanks You for Registration. ",
      userType: "user",
    });

    if (!sendEmail) throw new SetErrorResponse();

    return res.success({ email }, `OTP send to user's Email`);
  } catch (err) {
    console.log("Error from userRegisterController : " + err.message);
    return res.fail(err);
  }
};

exports.userVerifyOTPAndRegisterController = async (req, res, next) => {
  try {
    const { email, OTP } = req.body;
    const values = await getCacheOTP({ email, prefix: "register" });

    console.log({ OTP });
    console.log({ values });

    if (!(OTP == values?.otp))
      throw new SetErrorResponse("OTP validation failed", 403);
    const { firstName, lastName, phoneNumber, address, password } = values;

    const user = new User({
      email,
      firstName,
      lastName,
      phoneNumber,
      address,
      password,
    });

    const name = firstName + " " + lastName;
    user.name = name;

    await user.save();

    const userData = userDataPipelining(user);
    const token = jwt.sign(userData, customSecretKey(userData?._id), {
      expiresIn: "2d",
    });

    return res.success({ userData, token });
  } catch (err) {
    return res.fail(err);
  }
};

exports.userloginController = async (req, res, next) => {
  try {
    const { email, password, rememberMe, registrationIdToken } = req.body;
    const expiresIn = rememberMe ? "7d" : "2d";

    const existingUserData = await User.findOne(
      { email },
      "+salt +hashed_password"
    );
    // console.log(existingUserData);
    if (!existingUserData) {
      throw new SetErrorResponse("User doesn't exist", 404);
    }
    if (!existingUserData?.authentication(password)) {
      throw new SetErrorResponse("Unauthorized, Password Incorrect", 401);
    }
    const userData = userDataPipelining(existingUserData);

    await User.findOneAndUpdate(
      { email },
      {
        registrationIdToken: registrationIdToken,
      },
      { new: true }
    );
    const token = jwt.sign(userData, customSecretKey(existingUserData?._id), {
      expiresIn: expiresIn,
    });

    return res.success(
      { token, userData: { ...userData, image: existingUserData?.image } },
      "Login Successful !"
    );
  } catch (err) {
    return res.fail(err);
  }
};

exports.userlogoutController = async (req, res, next) => {
  try {
    const existingUserData = await User.findById({ _id: req.params.id });
    console.log(existingUserData);
    if (!existingUserData) {
      throw new SetErrorResponse("User doesn't exist", 404);
    }

    await User.findByIdAndUpdate(
      { _id: req.params.id },
      {
        registrationIdToken: null,
      },
      { new: true }
    );
    return res.success({}, "Login Successful !");
  } catch (err) {
    return res.fail(err);
  }
};
