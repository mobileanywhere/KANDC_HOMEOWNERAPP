import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';

const APP_NAME = 'K&C Homeowner';
const APP_NAME_TAG_LINE = 'On-Demand Home Services App';
var defaultPrimaryColor = Color(0xFFB5AA9F); // Color(0xFF5F60B9);

const DOMAIN_URL = 'http://44.250.15.123';
const BASE_URL = '$DOMAIN_URL/api/';

const DEFAULT_LANGUAGE = 'en';

/// You can change this to your Provider App package name
/// This will be used in Registered As Partner in Sign In Screen where your users can redirect to the Play/App Store for Provider App
/// You can specify in Admin Panel, These will be used if you don't specify in Admin Panel
const PROVIDER_PACKAGE_NAME = 'com.kc.owner';
const IOS_LINK_FOR_PARTNER = "";

const IOS_LINK_FOR_USER = '';

const DASHBOARD_AUTO_SLIDER_SECOND = 5;

const TERMS_CONDITION_URL = 'http://44.250.15.123/#/term-conditions';
const PRIVACY_POLICY_URL = 'http://44.250.15.123/#/privacy-policy';
const INQUIRY_SUPPORT_EMAIL = '';

/// You can add help line number here for contact. It's demo number
const HELP_LINE_NUMBER = '';

/// STRIPE PAYMENT DETAIL
const STRIPE_MERCHANT_COUNTRY_CODE = 'IN';
const STRIPE_CURRENCY_CODE = 'INR';

/// SADAD PAYMENT DETAIL
const SADAD_API_URL = 'https://api-s.sadad.qa';
const SADAD_PAY_URL = "https://d.sadad.qa";

Country defaultCountry() {
  return Country(
    phoneCode: '91',
    countryCode: 'IN',
    e164Sc: 91,
    geographic: true,
    level: 1,
    name: 'India',
    example: '9123456789',
    displayName: 'India (IN) [+91]',
    displayNameNoCountryCode: 'India (IN)',
    e164Key: '91-IN-0',
    fullExampleWithPlusSign: '+91---------',
  );
}
