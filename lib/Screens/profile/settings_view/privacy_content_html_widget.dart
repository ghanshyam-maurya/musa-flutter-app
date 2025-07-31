import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyContentHTMLWidget extends StatelessWidget {
  const PrivacyContentHTMLWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Html(
        data: _getPrivacyPolicyHtml(),
        style: {
          "body": Style(
            fontSize: FontSize(14.0),
            lineHeight: const LineHeight(1.5),
            color: Colors.black87,
            fontFamily: 'Arial, sans-serif',
          ),
          "h1": Style(
            fontSize: FontSize(24.0),
            fontWeight: FontWeight.bold,
            margin: Margins.only(bottom: 16.0),
          ),
          "h2": Style(
            fontSize: FontSize(18.0),
            fontWeight: FontWeight.bold,
            margin: Margins.only(top: 24.0, bottom: 12.0),
          ),
          "h3": Style(
            fontSize: FontSize(16.0),
            fontWeight: FontWeight.bold,
            margin: Margins.only(top: 20.0, bottom: 8.0),
          ),
          "p": Style(
            margin: Margins.only(bottom: 12.0),
          ),
          "li": Style(
            margin: Margins.only(bottom: 8.0),
          ),
          "ul": Style(
            margin: Margins.only(bottom: 16.0),
            // paddingLeft: const EdgeInsets.only(left: 20.0),
          ),
          "a": Style(
            color: Colors.blue,
            textDecoration: TextDecoration.underline,
          ),
          ".last-updated": Style(
            fontSize: FontSize(12.0),
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
            margin: Margins.only(bottom: 24.0),
          ),
          ".summary-intro": Style(
            fontStyle: FontStyle.italic,
            margin: Margins.only(bottom: 16.0),
          ),
          ".in-short": Style(
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w500,
          ),
        },
        onLinkTap: (url, attributes, element) async {
          if (url != null) {
            if (url.startsWith('#')) {
              // Handle internal links/anchors
              // You can implement scrolling to specific sections here
              print('Internal link: $url');
            } else if (url.startsWith('mailto:')) {
              // Handle email links
              final Uri emailUri = Uri.parse(url);
              if (await canLaunchUrl(emailUri)) {
                await launchUrl(emailUri);
              }
            } else {
              // Handle external links
              final Uri uri = Uri.parse(url);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            }
          }
        },
      ),
    );
  }

  String _getPrivacyPolicyHtml() {
    return '''
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="UTF-8">
        <title>Privacy Policy</title>
    </head>
    <body>
        <h1>PRIVACY POLICY</h1>
        <p class="last-updated">Last updated January 01, 2025</p>

        <p>This Privacy Notice for Never Ending Memory LLC (doing business as MUSA.ART) ("we," "us," or "our"), describes how and why we might access, collect, store, use, and/or share ("process") your personal information when you use our services ("Services"), including when you:</p>

        <ul>
            <li>Visit our website at MUSA.art or any website of ours that links to this Privacy Notice</li>
            <li>Download and use our mobile application (MUSA), or any other application of ours that links to this Privacy Notice</li>
            <li>Engage with us in other related ways, including any sales, marketing, or events</li>
        </ul>

        <p><strong>Questions or concerns?</strong> Reading this Privacy Notice will help you understand your privacy rights and choices. We are responsible for making decisions about how your personal information is processed. If you do not agree with our policies and practices, please do not use our Services. If you still have any questions or concerns, please contact us at MUSA_POLICY@MUSA.ART.</p>

        <h2>SUMMARY OF KEY POINTS</h2>

        <p class="summary-intro">This summary provides key points from our Privacy Notice, but you can find out more details about any of these topics by clicking the link following each key point or by using our <a href="#table-of-contents">table of contents</a> below to find the section you are looking for.</p>

        <p><strong>What personal information do we process?</strong> When you visit, use, or navigate our Services, we may process personal information depending on how you interact with us and the Services, the choices you make, and the products and features you use. Learn more about <a href="#personal-information">personal information you disclose to us</a>.</p>

        <p><strong>Do we process any sensitive personal information?</strong> Some of the information may be considered "special" or "sensitive" in certain jurisdictions, for example your racial or ethnic origins, sexual orientation, and religious beliefs. We do not process sensitive personal information.</p>

        <p><strong>Do we collect any information from third parties?</strong> We do not collect any information from third parties.</p>

        <p><strong>How do we process your information?</strong> We process your information to provide, improve, and administer our Services, communicate with you, for security and fraud prevention, and to comply with law. We may also process your information for other purposes with your consent. We process your information only when we have a valid legal reason to do so. Learn more about <a href="#how-we-process">how we process your information</a>.</p>

        <p><strong>In what situations and with which parties do we share personal information?</strong> We may share information in specific situations and with specific third parties. Learn more about <a href="#when-and-with-whom">when and with whom we share your personal information</a>.</p>

        <p><strong>How do we keep your information safe?</strong> We have adequate organizational and technical processes and procedures in place to protect your personal information. However, no electronic transmission over the internet or information storage technology can be guaranteed to be 100% secure, so we cannot promise or guarantee that hackers, cybercriminals, or other unauthorized third parties will not be able to defeat our security and improperly collect, access, steal, or modify your information. Learn more about <a href="#how-we-keep-safe">how we keep your information safe</a>.</p>

        <p><strong>What are your rights?</strong> Depending on where you are located geographically, the applicable privacy law may mean that you have certain rights regarding your personal information. Learn more about <a href="#your-privacy-rights">your privacy rights</a>.</p>

        <p><strong>How do you exercise your rights?</strong> The easiest way to exercise your rights is by submitting a <a href="#data-subject-access-request">data subject access request</a>, or by contacting us. We will consider and act upon any request in accordance with applicable data protection laws.</p>

        <p>Want to learn more about what we do with any information we collect? <a href="#full-privacy-notice">Review the Privacy Notice in full</a>.</p>

        <h2 id="table-of-contents">TABLE OF CONTENTS</h2>

        <ol>
            <li><a href="#what-information">WHAT INFORMATION DO WE COLLECT?</a></li>
            <li><a href="#how-we-process">HOW DO WE PROCESS YOUR INFORMATION?</a></li>
            <li><a href="#legal-bases">WHAT LEGAL BASES DO WE RELY ON TO PROCESS YOUR PERSONAL INFORMATION?</a></li>
            <li><a href="#when-and-with-whom">WHEN AND WITH WHOM DO WE SHARE YOUR PERSONAL INFORMATION?</a></li>
            <li><a href="#third-party-websites">WHAT IS OUR STANCE ON THIRD-PARTY WEBSITES?</a></li>
            <li><a href="#cookies">DO WE USE COOKIES AND OTHER TRACKING TECHNOLOGIES?</a></li>
            <li><a href="#ai-products">DO WE OFFER ARTIFICIAL INTELLIGENCE-BASED PRODUCTS?</a></li>
            <li><a href="#social-logins">HOW DO WE HANDLE YOUR SOCIAL LOGINS?</a></li>
            <li><a href="#how-long">HOW LONG DO WE KEEP YOUR INFORMATION?</a></li>
            <li><a href="#keep-safe">HOW DO WE KEEP YOUR INFORMATION SAFE?</a></li>
            <li><a href="#privacy-rights">WHAT ARE YOUR PRIVACY RIGHTS?</a></li>
            <li><a href="#do-not-track">CONTROLS FOR DO-NOT-TRACK FEATURES</a></li>
            <li><a href="#us-privacy-rights">DO UNITED STATES RESIDENTS HAVE SPECIFIC PRIVACY RIGHTS?</a></li>
            <li><a href="#other-regions">DO OTHER REGIONS HAVE SPECIFIC PRIVACY RIGHTS?</a></li>
            <li><a href="#updates">DO WE MAKE UPDATES TO THIS NOTICE?</a></li>
            <li><a href="#contact">HOW CAN YOU CONTACT US ABOUT THIS NOTICE?</a></li>
            <li><a href="#review-update-delete">HOW CAN YOU REVIEW, UPDATE, OR DELETE THE DATA WE COLLECT FROM YOU?</a></li>
        </ol>

        <h2 id="what-information">1. WHAT INFORMATION DO WE COLLECT?</h2>

        <h3>Personal information you disclose to us</h3>

        <p class="in-short"><strong>In Short:</strong> We collect personal information that you provide to us.</p>

        <p>We collect personal information that you voluntarily provide to us when you register on the Services, express an interest in obtaining information about us or our products and Services, when you participate in activities on the Services, or otherwise when you contact us.</p>

        <p><strong>Personal Information Provided by You.</strong> The personal information that we collect depends on the context of your interactions with us and the Services, the choices you make, and the products and features you use. The personal information we collect may include the following:</p>

        <ul>
            <li>names</li>
            <li>phone numbers</li>
            <li>email addresses</li>
            <li>billing addresses</li>
        </ul>

        <p><strong>Sensitive Information.</strong> We do not process sensitive information.</p>

        <p><strong>Social Media Login Data.</strong> We may provide you with the option to register with us using your existing social media account details, like your Facebook, X, or other social media account. If you choose to register in this way, we will collect certain profile information about you from the social media provider, as described in the section called "<a href="#social-logins">HOW DO WE HANDLE YOUR SOCIAL LOGINS?</a>"</p>

        <p><strong>Application Data.</strong> If you use our application(s), we also may collect the following information if you choose to provide us with access or permission:</p>

        <ul>
            <li><strong>Geolocation Information.</strong> We may request access or permission to track location-based information from your mobile device, either continuously or while you are using our mobile application(s), to provide certain location-based services. If you wish to change our access or permissions, you may do so in your device's settings.</li>
            <li><strong>Mobile Device Access.</strong> We may request access or permission to certain features from your mobile device, including your mobile device's calendar, contacts, camera, microphone, reminders, sms messages, social media accounts, storage, bluetooth, sensors, and other features. If you wish to change our access or permissions, you may do so in your device's settings.</li>
            <li><strong>Mobile Device Data.</strong> We automatically collect device information (such as your mobile device ID, model, and manufacturer), operating system, version information and system configuration information, device and application identification numbers, browser type and version, hardware model Internet service provider and/or mobile carrier, and Internet Protocol (IP) address (or proxy server). If you are using our application(s), we may also collect information about the phone network associated with your mobile device, your mobile device's operating system or platform, the type of mobile device you use, your mobile device's unique device ID, and information about the features of our application(s) you accessed.</li>
            <li><strong>Push Notifications.</strong> We may request to send you push notifications regarding your account or certain features of the application(s). If you wish to opt-out from receiving these types of communications, you may turn them off in your device's settings.</li>
        </ul>

        <p>This information is primarily needed to maintain the security and operation of our application(s), for troubleshooting, and for our internal analytics and reporting purposes.</p>

        <p>All personal information that you provide to us must be true, complete, and accurate, and you must notify us of any changes to such personal information.</p>

        <h3>Information automatically collected</h3>

        <p class="in-short"><strong>In Short:</strong> Some information — such as your Internet Protocol (IP) address and/or browser and device characteristics — is collected automatically when you visit our Services.</p>

        <p>We automatically collect certain information when you visit, use, or navigate the Services. This information does not reveal your specific identity (like your name or contact information) but may include device and usage information, such as your IP address, browser and device characteristics, operating system, language preferences, referring URLs, device name, country, location, information about how and when you use our Services, and other technical information. This information is primarily needed to maintain the security and operation of our Services, and for our internal analytics and reporting purposes.</p>

        <p>Like many businesses, we also collect information through cookies and similar technologies.</p>

        <p>The information we collect includes:</p>

        <ul>
            <li><strong>Log and Usage Data.</strong> Log and usage data is service-related, diagnostic, usage, and performance information our servers automatically collect when you access or use our Services and which we record in log files. Depending on how you interact with us, this log data may include your IP address, device information, browser type, and settings and information about your activity in the Services (such as the date/time stamps associated with your usage, pages and files viewed, searches, and other actions you take such as which features you use), device event information (such as system activity, error reports (sometimes called "crash dumps"), and hardware settings).</li>
            <li><strong>Device Data.</strong> We collect device data such as information about your computer, phone, tablet, or other device you use to access the Services. Depending on the device used, this device data may include information such as your IP address (or proxy server), device and application identification numbers, location, browser type, hardware model, Internet service provider and/or mobile carrier, operating system, and system configuration information.</li>
            <li><strong>Location Data.</strong> We collect location data such as information about your device's location, which can be either precise or imprecise. How much information we collect depends on the type and settings of the device you use to access the Services. For example, we may use GPS and other technologies to collect geolocation data that tells us your current location (based on your IP address). You can opt out of allowing us to collect this information either by refusing access to the information or by disabling your Location setting on your device. However, if you choose to opt out, you may not be able to use certain aspects of the Services.</li>
        </ul>

        <h3>Google API</h3>

        <p>Our use of information received from Google APIs will adhere to <a href="https://developers.google.com/terms/api-services-user-data-policy" target="_blank">Google API Services User Data Policy</a>, including the <a href="https://developers.google.com/terms/api-services-user-data-policy#limited-use" target="_blank">Limited Use requirements</a>.</p>

        <h2 id="how-we-process">2. HOW DO WE PROCESS YOUR INFORMATION?</h2>

        <p class="in-short"><strong>In Short:</strong> We process your information to provide, improve, and administer our Services, communicate with you, for security and fraud prevention, and to comply with law. We process the personal information for the following purposes listed below. We may also process your information for other purposes only with your prior explicit consent.</p>

        <p>We process your <strong>personal information for a variety of reasons, depending on how you interact with our Services, including:</strong></p>

        <ul>
            <li><strong>To facilitate account creation and authentication and otherwise manage user accounts.</strong> We may process your information so you can create and log in to your account, as well as keep your account in working order.</li>
            <li><strong>To deliver and facilitate delivery of services to the user.</strong> We may process your information to provide you with the requested service.</li>
            <li><strong>To respond to user inquiries/offer support to users.</strong> We may process your information to respond to your inquiries and solve any potential issues you might have with the requested service.</li>
            <li><strong>To send administrative information to you.</strong> We may process your information to send you details about our products and services, changes to our terms and policies, and other similar information.</li>
        </ul>

    </body>
    </html>
    ''';
  }
}
