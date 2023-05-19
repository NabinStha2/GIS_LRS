exports.userDataPipelining = (userData) => {
  const {
    _id,
    email,
    phoneNumber,
    firstName,
    lastName,
    address,
    registrationIdToken,
  } = userData;
  return {
    _id,
    email,
    phoneNumber,
    firstName,
    lastName,
    address,
    registrationIdToken,
  };
};
