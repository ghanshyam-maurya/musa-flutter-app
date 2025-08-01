import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html_table/flutter_html_table.dart';

class PrivacyContentHTMLWidget extends StatelessWidget {
  const PrivacyContentHTMLWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(6.0),
      child: Html(
        data: _getPrivacyPolicyHtml(),
        extensions: [
          TableHtmlExtension(),
        ],
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
              //if (await canLaunchUrl(emailUri)) {
                await launchUrl(emailUri);
              //}
            } else {
              // Handle external links
              final Uri uri = Uri.parse(url);
              print('External link: $url');
              //if (await canLaunchUrl(uri)) {
                print('Launching URL: $url');
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              //}
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

        <p>This Privacy Notice for Never Ending Memory LLC (doing business as MUSA.ART) ("<strong>we</strong>," "<strong>us</strong>," or "<strong>our</strong>"), describes how and why we might access, collect, store, use, and/or share ("<strong>process</strong>") your personal information when you use our services ("<strong>Services</strong>"), including when you:</p>

        <ul>
            <li>Visit our website at MUSA.art or any website of ours that links to this Privacy Notice</li>
            <li>Download and use our mobile application (MUSA), or any other application of ours that links to this Privacy Notice</li>
            <li>Engage with us in other related ways, including any sales, marketing, or events</li>
        </ul>

        <p><strong>Questions or concerns?</strong> Reading this Privacy Notice will help you understand your privacy rights and choices. We are responsible for making decisions about how your personal information is processed. If you do not agree with our policies and practices, please do not use our Services. If you still have any questions or concerns, please contact us at MUSA_POLICY@MUSA.ART.</p>

        <h2>SUMMARY OF KEY POINTS</h2>

        <p class="summary-intro">This summary provides key points from our Privacy Notice, but you can find out more details about any of these topics by clicking the link following each key point or by using our <a href="#table-of-contents">table of contents</a> below to find the section you are looking for.</p>

        <p><strong>What personal information do we process?</strong> When you visit, use, or navigate our Services, we may process personal information depending on how you interact with us and the Services, the choices you make, and the products and features you use. Learn more about <a href="#what-information">personal information you disclose to us</a>.</p>

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

         <!-- section 1 -->
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

        <!-- section 2 -->
        <h2 id="how-we-process">2. HOW DO WE PROCESS YOUR INFORMATION?</h2>

        <p class="in-short"><strong>In Short:</strong> We process your information to provide, improve, and administer our Services, communicate with you, for security and fraud prevention, and to comply with law. We process the personal information for the following purposes listed below. We may also process your information for other purposes only with your prior explicit consent.</p>

        <p>We process your <strong>personal information for a variety of reasons, depending on how you interact with our Services, including:</strong></p>

        <ul>
            <li><strong>To facilitate account creation and authentication and otherwise manage user accounts.</strong> We may process your information so you can create and log in to your account, as well as keep your account in working order.</li>
            <li><strong>To deliver and facilitate delivery of services to the user.</strong> We may process your information to provide you with the requested service.</li>
            <li><strong>To respond to user inquiries/offer support to users.</strong> We may process your information to respond to your inquiries and solve any potential issues you might have with the requested service.</li>
            <li><strong>To send administrative information to you.</strong> We may process your information to send you details about our products and services, changes to our terms and policies, and other similar information.</li>
             <li><strong>To fulfill and manage your orders. </strong>  We may process your information to fulfill and manage your orders, payments, returns, and exchanges made through the Services.</li>
              <li><strong>To enable user-to-user communications. </strong>  We may process your information if you choose to use any of our offerings that allow for communication with another user.</li>
            <li><strong>To save or protect an individual's vital interest.  </strong>  We may process your information when necessary to save or protect an individual's vital interest, such as to prevent harm.</li> 
        </ul>


        <!-- section 3 -->
        <h2 id="legal-bases">3. WHAT LEGAL BASES DO WE RELY ON TO PROCESS YOUR INFORMATION?</h2>
        <p class="in-short"><strong>In Short:</strong> We only process your personal information when we believe it is necessary and we have a valid legal reason (i.e., legal basis) to do so under applicable law, like with your consent, to comply with laws, to provide you with services to enter into or fulfill our contractual obligations, to protect your rights, or to fulfill our legitimate business interests.</p>

        <h3><em>If you are located in the EU or UK, this section applies to you.</em></h3>
        <p>The General Data Protection Regulation (GDPR) and UK GDPR require us to explain the valid legal bases we rely on in order to process your personal information. As such, we may rely on the following legal bases to process your personal information:</p>
        <ul>
          <li><strong>Consent.</strong> We may process your information if you have given us permission (i.e., consent) to use your personal information for a specific purpose. You can withdraw your consent at any time. Learn more about <a href="#withdraw-consent">withdrawing your consent</a>.</li>
          <li><strong>Performance of a Contract.</strong> We may process your personal information when we believe it is necessary to fulfill our contractual obligations to you, including providing our Services or at your request prior to entering into a contract with you.</li>
          <li><strong>Legal Obligations.</strong> We may process your information where we believe it is necessary for compliance with our legal obligations, such as to cooperate with a law enforcement body or regulatory agency, exercise or defend our legal rights, or disclose your information as evidence in litigation in which we are involved.</li>
          <li><strong>Vital Interests.</strong> We may process your information where we believe it is necessary to protect your vital interests or the vital interests of a third party, such as situations involving potential threats to the safety of any person.</li>
        </ul>

        <h3><em>If you are located in Canada, this section applies to you.</em></h3>
        <p>We may process your information if you have given us specific permission (i.e., express consent) to use your personal information for a specific purpose, or in situations where your permission can be inferred (i.e., implied consent). You can <a href="#withdraw-consent">withdraw your consent</a> at any time.</p>
        <p>In some exceptional cases, we may be legally permitted under applicable law to process your information without your consent, including, for example:</p>
        <ul>
          <li>If collection is clearly in the interests of an individual and consent cannot be obtained in a timely way</li>
          <li>For investigations and fraud detection and prevention</li>
          <li>For business transactions provided certain conditions are met</li>
          <li>If it is contained in a witness statement and the collection is necessary to assess, process, or settle an insurance claim</li>
          <li>For identifying injured, ill, or deceased persons and communicating with next of kin</li>
          <li>If we have reasonable grounds to believe an individual has been, is, or may be victim of financial abuse</li>
          <li>If it is reasonable to expect collection and use with consent would compromise the availability or the accuracy of the information and the collection is reasonable for purposes related to investigating a breach of an agreement or a contravention of the laws of Canada or a province</li>
          <li>If disclosure is required to comply with a subpoena, warrant, court order, or rules of the court relating to the production of records</li>
          <li>If it was produced by an individual in the course of their employment, business, or profession and the collection is consistent with the purposes for which the information was produced</li>
          <li>If the collection is solely for journalistic, artistic, or literary purposes</li>
          <li>If the information is publicly available and is specified by the regulations</li>
          <li>We may disclose de-identified information for approved research or statistics projects, subject to ethics oversight and confidentiality commitments</li>
        </ul>

        <!-- section 4 -->
        <h2 id="when-and-with-whom">4. WHEN AND WITH WHOM DO WE SHARE YOUR PERSONAL INFORMATION?</h2>
        <p class="in-short"><strong>In Short:</strong> We may share information in specific situations described in this section and/or with the following third parties.</p>
        <p>We may need to share your personal information in the following situations:</p>
        <ul>
          <li><strong>Business Transfers.</strong> We may share or transfer your information in connection with, or during negotiations of, any merger, sale of company assets, financing, or acquisition of all or a portion of our business to another company.</li>
          <li><strong>When we use Google Maps Platform APIs.</strong> We may share your information with certain Google Maps Platform APIs (e.g., Google Maps API, Places API). We use certain Google Maps Platform APIs to retrieve certain information when you make location-specific requests. This includes: zip code location; and other similar information. A full list of what we use information for can be found in this section and in the previous section titled <a href="#how-we-process">"HOW DO WE PROCESS YOUR INFORMATION?"</a> Google Maps uses GPS, Wi-Fi, and cell towers to estimate your location. GPS is accurate to about 20 meters, while Wi-Fi and cell towers help improve accuracy when GPS signals are weak, like indoors. This data helps Google Maps provide directions, but it is not always perfectly precise. We obtain and store on your device ("cache") your location. You may revoke your consent anytime by contacting us at the contact details provided at the end of this document. The Google Maps Platform APIs that we use store and access cookies and other information on your devices. If you are a user currently in the European Economic Area (EU countries, Iceland, Liechtenstein, and Norway) or the United Kingdom, please take a look at our Cookie Notice.</li>
          <li><strong>Offer Wall.</strong> Our application(s) may display a third-party hosted "offer wall." Such an offer wall allows third-party advertisers to offer virtual currency, gifts, or other items to users in return for the acceptance and completion of an advertisement offer. Such an offer wall may appear in our application(s) and be displayed to you based on certain data, such as your geographic area or demographic information. When you click on an offer wall, you will be brought to an external website belonging to other persons and will leave our application(s). A unique identifier, such as your user ID, will be shared with the offer wall provider in order to prevent fraud and properly credit your account with the relevant reward.</li>
        </ul>


        <!-- section 5 -->
        <h2 id="third-party-websites">5. WHAT IS OUR STANCE ON THIRD-PARTY WEBSITES?</h2>
        <p class="in-short"><strong>In Short:</strong> We are not responsible for the safety of any information that you share with third parties that we may link to or who advertise on our Services, but are not affiliated with, our Services.</p>
        <p>The Services, including our offer wall, may link to third-party websites, online services, or mobile applications and/or contain advertisements from third parties that are not affiliated with us and which may link to other websites, services, or applications. Accordingly, we do not make any guarantee regarding any such third parties, and we will not be liable for any loss or damage caused by the use of such third-party websites, services, or applications. The inclusion of a link towards a third-party website, service, or application does not imply an endorsement by us. We cannot guarantee the safety and privacy of data you provide to any third-party websites. Any data collected by third parties is not covered by this Privacy Notice. We are not responsible for the content or privacy and security practices and policies of any third parties, including other websites, services, or applications that may be linked to or from the Services. You should review the policies of such third parties and contact them directly to respond to your questions.</p>


        <!-- section 6 -->
        <h2 id="cookies">6. DO WE USE COOKIES AND OTHER TRACKING TECHNOLOGIES?</h2>
        <p class="in-short"><strong>In Short:</strong> We may use cookies and other tracking technologies to collect and store your information.</p>
        <p>We may use cookies and similar tracking technologies (like web beacons and pixels) to gather information when you interact with our Services. Some online tracking technologies help us maintain the security of our Services and your account, prevent crashes, fix bugs, save your preferences, and assist with basic site functions.</p>
        <p>We also permit third parties and service providers to use online tracking technologies on our Services for analytics and advertising, including to help manage and display advertisements, to tailor advertisements to your interests, or to send abandoned shopping cart reminders (depending on your communication preferences). The third parties and service providers use their technology to provide advertising about products and services tailored to your interests which may appear either on our Services or on other websites.</p>
        <p>To the extent these online tracking technologies are deemed to be a "sale"/"sharing" (which includes targeted advertising, as defined under the applicable laws) under applicable US state laws, you can opt out of these online tracking technologies by submitting a request as described below under section <a href="#us-privacy-rights">"DO UNITED STATES RESIDENTS HAVE SPECIFIC PRIVACY RIGHTS?"</a></p>
        <p>Specific information about how we use such technologies and how you can refuse certain cookies is set out in our Cookie Notice.</p>
        <h3>Google Analytics</h3>
        <p>We may share your information with Google Analytics to track and analyze the use of the Services. The Google Analytics Advertising Features that we may use include: Google Analytics Demographics and Interests Reporting. To opt out of being tracked by Google Analytics across the Services, visit <a href="https://tools.google.com/dlpage/gaoptout" target="_blank">https://tools.google.com/dlpage/gaoptout</a>. You can opt out of Google Analytics Advertising Features through <a href="https://www.google.com/settings/ads" target="_blank">Ads Settings</a> and Ad Settings for mobile apps. Other opt out means include <a href="http://optout.networkadvertising.org/" target="_blank">http://optout.networkadvertising.org/</a> and <a href="http://www.networkadvertising.org/mobile-choice" target="_blank">http://www.networkadvertising.org/mobile-choice</a>. For more information on the privacy practices of Google, please visit the <a href="https://policies.google.com/privacy" target="_blank">Google Privacy & Terms page</a>.</p>


        <!-- section 7 -->
        <h2 id="ai-products">7. DO WE OFFER ARTIFICIAL INTELLIGENCE-BASED PRODUCTS?</h2>
        <p class="in-short"><strong>In Short:</strong> We offer products, features, or tools powered by artificial intelligence, machine learning, or similar technologies.</p>
        <p>As part of our Services, we offer products, features, or tools powered by artificial intelligence, machine learning, or similar technologies (collectively, "AI Products"). These tools are designed to enhance your experience and provide you with innovative solutions. The terms in this Privacy Notice govern your use of the AI Products within our Services.</p>
        <h3>Use of AI Technologies</h3>
        <p>We provide the AI Products through third-party service providers ("AI Service Providers"), including Amazon Web Services (AWS) AI. As outlined in this Privacy Notice, your input, output, and personal information will be shared with and processed by these AI Service Providers to enable your use of our AI Products for purposes outlined in <a href="#legal-bases">"WHAT LEGAL BASES DO WE RELY ON TO PROCESS YOUR PERSONAL INFORMATION?"</a> You must not use the AI Products in any way that violates the terms or policies of any AI Service Provider.</p>
        <h4>Our AI Products</h4>
        <p>Our AI Products are designed for the following functions:</p>
        <ul>
          <li>AI automation</li>
          <li>AI development</li>
          <li>Image analysis</li>
          <li>Blockchain</li>
          <li>AI translation</li>
        </ul>
        <h4>How We Process Your Data Using AI</h4>
        <p>All personal information processed using our AI Products is handled in line with our Privacy Notice and our agreement with third parties. This ensures high security and safeguards your personal information throughout the process, giving you peace of mind about your data's safety.</p>

        <!-- section 8 -->
        <h2 id="social-logins">8. HOW DO WE HANDLE YOUR SOCIAL LOGINS?</h2>
        <p class="in-short"><strong>In Short:</strong> If you choose to register or log in to our Services using a social media account, we may have access to certain information about you.</p>
        <p>Our Services offer you the ability to register and log in using your third-party social media account details (like your Facebook or X logins). Where you choose to do this, we will receive certain profile information about you from your social media provider. The profile information we receive may vary depending on the social media provider concerned, but will often include your name, email address, friends list, and profile picture, as well as other information you choose to make public on such a social media platform.</p>
        <p>We will use the information we receive only for the purposes that are described in this Privacy Notice or that are otherwise made clear to you on the relevant Services. Please note that we do not control, and are not responsible for, other uses of your personal information by your third-party social media provider. We recommend that you review their privacy notice to understand how they collect, use, and share your personal information, and how you can set your privacy preferences on their sites and apps.</p>


        <!-- section 9 -->
        <h2 id="how-long">9. HOW LONG DO WE KEEP YOUR INFORMATION?</h2>
        <p class="in-short"><strong>In Short:</strong> We keep your information for as long as necessary to fulfill the purposes outlined in this Privacy Notice unless otherwise required by law.</p>
        <p>We will only keep your personal information for as long as it is necessary for the purposes set out in this Privacy Notice, unless a longer retention period is required or permitted by law (such as tax, accounting, or other legal requirements). No purpose in this notice will require us keeping your personal information for longer than twelve (12) months past the termination of the user's account.</p>
        <p>When we have no ongoing legitimate business need to process your personal information, we will either delete or anonymize such information, or, if this is not possible (for example, because your personal information has been stored in backup archives), then we will securely store your personal information and isolate it from any further processing until deletion is possible.</p>


        <!-- section 10 -->
        <h2 id="keep-safe">10. HOW DO WE KEEP YOUR INFORMATION SAFE?</h2>
        <p class="in-short"><strong>In Short:</strong> We aim to protect your personal information through a system of organizational and technical security measures.</p>
        <p>We have implemented appropriate and reasonable technical and organizational security measures designed to protect the security of any personal information we process. However, despite our safeguards and efforts to secure your information, no electronic transmission over the Internet or information storage technology can be guaranteed to be 100% secure, so we cannot promise or guarantee that hackers, cybercriminals, or other unauthorized third parties will not be able to defeat our security and improperly collect, access, steal, or modify your information. Although we will do our best to protect your personal information, transmission of personal information to and from our Services is at your own risk. You should only access the Services within a secure environment.</p>


        <!-- section 11 -->
        <h2 id="privacy-rights">11. WHAT ARE YOUR PRIVACY RIGHTS?</h2>
        <p class="in-short"><strong>In Short:</strong> Depending on your state of residence in the US or in some regions, such as the European Economic Area (EEA), United Kingdom (UK), Switzerland, and Canada, you have rights that allow you greater access to and control over your personal information. You may review, change, or terminate your account at any time, depending on your country, province, or state of residence.</p>
        <p>In some regions (like the EEA, UK, Switzerland, and Canada), you have certain rights under applicable data protection laws. These may include the right (i) to request access and obtain a copy of your personal information, (ii) to request rectification or erasure; (iii) to restrict the processing of your personal information; (iv) if applicable, to data portability; and (v) not to be subject to automated decision-making. If a decision that produces legal or similarly significant effects is made solely by automated means, we will inform you, explain the main factors, and offer a simple way to request human review. In certain circumstances, you may also have the right to object to the processing of your personal information. You can make such a request by contacting us by using the contact details provided in the section <a href="#contact">"HOW CAN YOU CONTACT US ABOUT THIS NOTICE?"</a> below.</p>
        <p>We will consider and act upon any request in accordance with applicable data protection laws.</p>
        <p>If you are located in the EEA or UK and you believe we are unlawfully processing your personal information, you also have the right to complain to your <a href="https://edpb.europa.eu/about-edpb/board/members_en" target="_blank">Member State data protection authority</a>, or <a href="https://ico.org.uk/make-a-complaint/" target="_blank">UK data protection authority</a>.</p>
        <p>If you are located in Switzerland, you may contact the <a href="https://www.edoeb.admin.ch/edoeb/en/home.html" target="_blank">Federal Data Protection and Information Commissioner</a>.</p>
        <p><strong>Withdrawing your consent:</strong> If we are relying on your consent to process your personal information, which may be express and/or implied consent depending on the applicable law, you have the right to withdraw your consent at any time. You can withdraw your consent at any time by contacting us by using the contact details provided in the section <a href="#contact">"HOW CAN YOU CONTACT US ABOUT THIS NOTICE?"</a> below.</p>
        <p>However, please note that this will not affect the lawfulness of the processing before its withdrawal nor, when applicable law allows, will it affect the processing of your personal information conducted in reliance on lawful processing grounds other than consent.</p>
        <p><strong>Opting out of marketing and promotional communications:</strong> You can unsubscribe from our marketing and promotional communications at any time by clicking on the unsubscribe link in the emails that we send, replying "STOP" or "UNSUBSCRIBE" to the SMS messages that we send, or by contacting us using the details provided in the section <a href="#contact">"HOW CAN YOU CONTACT US ABOUT THIS NOTICE?"</a> below. You will then be removed from the marketing lists. However, we may still communicate with you — for example, to send you service-related messages that are necessary for the administration and use of your account, to respond to service requests, or for other non-marketing purposes.</p>
        <p>No mobile information will be shared with third parties or affiliates for marketing or promotional purposes. Information sharing to subcontractors in support services, such as customer service, is permitted. All other use case categories exclude text messaging originator opt-in data and consent; this information will not be shared with third parties.</p>
        <h3>Account Information</h3>
        <p>If you would at any time like to review or change the information in your account or terminate your account, you can:</p>
        <ul>
          <li>Log in to your account settings and update your user account.</li>
        </ul>
        <p>Upon your request to terminate your account, we will deactivate or delete your account and information from our active databases. However, we may retain some information in our files to prevent fraud, troubleshoot problems, assist with any investigations, enforce our legal terms and/or comply with applicable legal requirements.</p>
        <p><strong>Cookies and similar technologies:</strong> Most Web browsers are set to accept cookies by default. If you prefer, you can usually choose to set your browser to remove cookies and to reject cookies. If you choose to remove cookies or reject cookies, this could affect certain features or services of our Services. You may also <a href="https://optout.aboutads.info/" target="_blank">opt out of interest-based advertising by advertisers on our Services</a>.</p>
        <p>If you have questions or comments about your privacy rights, you may email us at MUSA_POLICY@MUSA.ART.</p>


        <!-- section 12 -->
        <h2 id="do-not-track">12. CONTROLS FOR DO-NOT-TRACK FEATURES</h2>
        <p>Most web browsers and some mobile operating systems and mobile applications include a Do-Not-Track ("DNT") feature or setting you can activate to signal your privacy preference not to have data about your online browsing activities monitored and collected. At this stage, no uniform technology standard for recognizing and implementing DNT signals has been finalized. As such, we do not currently respond to DNT browser signals or any other mechanism that automatically communicates your choice not to be tracked online. If a standard for online tracking is adopted that we must follow in the future, we will inform you about that practice in a revised version of this Privacy Notice.</p>
        <p>California law requires us to let you know how we respond to web browser DNT signals. Because there currently is not an industry or legal standard for recognizing or honoring DNT signals, we do not respond to them at this time.</p>


         <!-- section 13 -->
        <!-- section 13 -->
        <h2 id="us-privacy-rights">13. DO UNITED STATES RESIDENTS HAVE SPECIFIC PRIVACY RIGHTS?</h2>
        <p class="in-short"><strong>In Short:</strong> If you are a resident of California, Colorado, Connecticut, Delaware, Florida, Indiana, Iowa, Kentucky, Maryland, Minnesota, Montana, Nebraska, New Hampshire, New Jersey, Oregon, Rhode Island, Tennessee, Texas, Utah, or Virginia, you may have the right to request access to and receive details about the personal information we maintain about you and how we have processed it, correct inaccuracies, get a copy of, or delete your personal information. You may also have the right to withdraw your consent to our processing of your personal information. These rights may be limited in some circumstances by applicable law. More information is provided below.</p>
        <h4>Categories of Personal Information We Collect</h4>
        <p>The table below shows the categories of personal information we have collected in the past twelve (12) months. The table includes illustrative examples of each category and does not reflect the personal information we collect from you. For a comprehensive inventory of all personal information we process, please refer to the section '<a href="#info-collect">WHAT INFORMATION DO WE COLLECT?</a>'.</p>
        <table style="border-collapse:collapse;margin-bottom:16px;">
          <tr>
            <th style="border:1px solid #888;padding:1px;">Category</th>
            <th style="border:1px solid #888;padding:1px;">Examples</th>
            <th style="border:1px solid #888;padding:1px;">Collected</th>
          </tr>
          <tr>
            <td style="border:1px solid #888;padding:1px;">A. Identifiers</td>
            <td style="border:1px solid #888;padding:1px;">Contact details, such as real name, alias, postal address, telephone or mobile contact number, unique personal identifier, online identifier, Internet Protocol address, email address, and account name</td>
            <td style="border:1px solid #888;padding:1px;">YES</td>
          </tr>
          <tr>
            <td style="border:1px solid #888;padding:1px;">B. Personal information as defined in the California Customer Records statute</td>
            <td style="border:1px solid #888;padding:1px;">Name, contact information, education, employment, employment history, and financial information</td>
            <td style="border:1px solid #888;padding:1px;">NO</td>
          </tr>
          <tr>
            <td style="border:1px solid #888;padding:1px;">C. Protected classification characteristics under state or federal law</td>
            <td style="border:1px solid #888;padding:1px;">Gender, age, date of birth, race and ethnicity, national origin, marital status, and other demographic data</td>
            <td style="border:1px solid #888;padding:1px;">YES</td>
          </tr>
          <tr>
            <td style="border:1px solid #888;padding:1px;">D. Commercial information</td>
            <td style="border:1px solid #888;padding:1px;">Transaction information, purchase history, financial details, and payment information</td>
            <td style="border:1px solid #888;padding:1px;">NO</td>
          </tr>
          <tr>
            <td style="border:1px solid #888;padding:1px;">E. Biometric information</td>
            <td style="border:1px solid #888;padding:1px;">Fingerprints and voiceprints</td>
            <td style="border:1px solid #888;padding:1px;">NO</td>
          </tr>
          <tr>
            <td style="border:1px solid #888;padding:1px;">F. Internet or other similar network activity</td>
            <td style="border:1px solid #888;padding:1px;">Browsing history, search history, online behavior, interest data, and interactions with our and other websites, applications, systems, and advertisements</td>
            <td style="border:1px solid #888;padding:1px;">YES</td>
          </tr>
          <tr>
            <td style="border:1px solid #888;padding:1px;">G. Geolocation data</td>
            <td style="border:1px solid #888;padding:1px;">Device location</td>
            <td style="border:1px solid #888;padding:1px;">YES</td>
          </tr>
          <tr>
            <td style="border:1px solid #888;padding:1px;">H. Audio, electronic, sensory, or similar information</td>
            <td style="border:1px solid #888;padding:1px;">Images and audio, video or call recordings created in connection with our business activities</td>
            <td style="border:1px solid #888;padding:1px;">YES</td>
          </tr>
          <tr>
            <td style="border:1px solid #888;padding:1px;">I. Professional or employment-related information</td>
            <td style="border:1px solid #888;padding:1px;">Business contact details in order to provide you our Services at a business level or job title, work history, and professional qualifications if you apply for a job with us</td>
            <td style="border:1px solid #888;padding:1px;">NO</td>
          </tr>
          <tr>
            <td style="border:1px solid #888;padding:1px;">J. Education Information</td>
            <td style="border:1px solid #888;padding:1px;">Student records and directory information</td>
            <td style="border:1px solid #888;padding:1px;">NO</td>
          </tr>
          <tr>
            <td style="border:1px solid #888;padding:1px;">K. Inferences drawn from collected personal information</td>
            <td style="border:1px solid #888;padding:1px;">Inferences drawn from any of the collected personal information listed above to create a profile or summary about, for example, an individual's preferences and characteristics</td>
            <td style="border:1px solid #888;padding:1px;">NO</td>
          </tr>
          <tr>
            <td style="border:1px solid #888;padding:1px;">L. Sensitive personal Information</td>
            <td style="border:1px solid #888;padding:1px;"></td>
            <td style="border:1px solid #888;padding:1px;">NO</td>
          </tr>
        </table>
        <p>We may also collect other personal information outside of these categories through instances where you interact with us in person, online, or by phone or mail in the context of:</p>
        <ul>
          <li>Receiving help through our customer support channels;</li>
          <li>Participation in customer surveys or contests; and</li>
          <li>Facilitation in the delivery of our Services and to respond to your inquiries.</li>
        </ul>
        <p>We will use and retain the collected personal information as needed to provide the Services or for:</p>
        <ul>
          <li>Category A - As long as the user has an account with us</li>
          <li>Category C - As long as the user has an account with us</li>
          <li>Category F - As long as the user has an account with us</li>
          <li>Category G - As long as the user has an account with us</li>
          <li>Category H - As long as the user has an account with us</li>
        </ul>
        <h4>Sources of Personal Information</h4>
        <p>Learn more about the sources of personal information we collect in <a href="#info-collect">"WHAT INFORMATION DO WE COLLECT?"</a></p>
        <h4>How We Use and Share Personal Information</h4>
        <p>Learn more about how we use your personal information in the section, <a href="#process-info">"HOW DO WE PROCESS YOUR INFORMATION?"</a></p>
        <h5>Will your information be shared with anyone else?</h5>
        <p>We may disclose your personal information with our service providers pursuant to a written contract between us and each service provider. Learn more about how we disclose personal information in the section, <a href="#share-info">"WHEN AND WITH WHOM DO WE SHARE YOUR PERSONAL INFORMATION?"</a></p>
        <p>We may use your personal information for our own business purposes, such as for undertaking internal research for technological development and demonstration. This is not considered to be "selling" of your personal information.</p>
        <p>We have not disclosed, sold, or shared any personal information to third parties for a business or commercial purpose in the preceding twelve (12) months. We will not sell or share personal information in the future belonging to website visitors, users, and other consumers.</p>
        <h4>Your Rights</h4>
        <p>You have rights under certain US state data protection laws. However, these rights are not absolute, and in certain cases, we may decline your request as permitted by law. These rights include:</p>
        <ul>
          <li><strong>Right to know</strong> whether or not we are processing your personal data</li>
          <li><strong>Right to access</strong> your personal data</li>
          <li><strong>Right to correct</strong> inaccuracies in your personal data</li>
          <li><strong>Right to request the deletion</strong> of your personal data</li>
          <li><strong>Right to obtain a copy</strong> of the personal data you previously shared with us</li>
          <li><strong>Right to non-discrimination</strong> for exercising your rights</li>
          <li><strong>Right to opt out</strong> of the processing of your personal data if it is used for targeted advertising (or sharing as defined under California's privacy law), the sale of personal data, or profiling in furtherance of decisions that produce legal or similarly significant effects ("profiling")</li>
        </ul>
        <p>Depending upon the state where you live, you may also have the following rights:</p>
        <ul>
          <li>Right to access the categories of personal data being processed (as permitted by applicable law, including the privacy law in Minnesota)</li>
          <li>Right to obtain a list of the categories of third parties to which we have disclosed personal data (as permitted by applicable law, including the privacy law in California, Delaware, and Maryland)</li>
          <li>Right to obtain a list of specific third parties to which we have disclosed personal data (as permitted by applicable law, including the privacy law in Minnesota and Oregon)</li>
          <li>Right to review, understand, question, and correct how personal data has been profiled (as permitted by applicable law, including the privacy law in Minnesota)</li>
          <li>Right to limit use and disclosure of sensitive personal data (as permitted by applicable law, including the privacy law in California)</li>
          <li>Right to opt out of the collection of sensitive data and personal data collected through the operation of a voice or facial recognition feature (as permitted by applicable law, including the privacy law in Florida)</li>
        </ul>
        <h4>How to Exercise Your Rights</h4>
        <p>To exercise these rights, you can contact us by submitting a <a href="#" target="_blank">data subject access request</a>, or by referring to the contact details at the bottom of this document.</p>
        <p>We will honor your opt-out preferences if you enact the <a href="#" target="_blank">Global Privacy Control</a> (GPC) opt-out signal on your browser.</p>
        <p>Under certain US state data protection laws, you can designate an authorized agent to make a request on your behalf. We may deny a request from an authorized agent that does not submit proof that they have been validly authorized to act on your behalf in accordance with applicable laws.</p>
        <h5>Request Verification</h5>
        <p>Upon receiving your request, we will need to verify your identity to determine you are the same person about whom we have the information in our system. We will only use personal information provided in your request to verify your identity or authority to make the request. However, if we cannot verify your identity from the information already maintained by us, we may request that you provide additional information for the purposes of verifying your identity and for security or fraud-prevention purposes.</p>
        <p>If you submit the request through an authorized agent, we may need to collect additional information to verify your identity before processing your request and the agent will need to provide a written and signed permission from you to submit such request on your behalf.</p>
        <h5>Appeals</h5>
        <p>Under certain US state data protection laws, if we decide to take action regarding your request, you may appeal our decision by emailing us at MUSA_POLICY@MUSA.ART. We will inform you in writing of any action taken or not taken in response to the appeal, including a written explanation of the reasons for the decisions. If your appeal is denied, you may submit a complaint to your state attorney general.</p>
        <h4>California "Shine The Light" Law</h4>
        <p>California Civil Code Section 1798.83, also known as the "Shine The Light" law, permits our users who are California residents to request and obtain from us, once a year and free of charge, information about categories of personal information (if any) we disclosed to third parties for direct marketing purposes and the names and addresses of all third parties with which we shared personal information in the immediately preceding calendar year. If you are a California resident and would like to make such a request, please submit your request in writing to us by using the contact details provided in the section <a href="#contact">"HOW CAN YOU CONTACT US ABOUT THIS NOTICE?"</a></p>


        <!-- section 14 -->
        <h2 id="other-regions">14. DO OTHER REGIONS HAVE SPECIFIC PRIVACY RIGHTS?</h2>
        <p class="in-short"><strong>In Short:</strong> You may have additional rights based on the country you reside in.</p>

        <h4>Australia and New Zealand</h4>
        <p>We collect and process your personal information under the obligations and conditions set by Australia's Privacy Act 1988 and New Zealand's Privacy Act 2020 (Privacy Act).</p>
        <p>This Privacy Notice satisfies the notice requirements defined in both Privacy Acts, in particular: what personal information we collect from you, from which sources, for which purposes, and other recipients of your personal information.</p>
        <p>If you do not wish to provide the personal information necessary to fulfill their applicable purpose, it may affect our ability to provide our services, in particular:</p>
        <ul>
          <li>offer you the products or services that you want</li>
          <li>respond to or help with your requests</li>
          <li>manage your account with us</li>
          <li>confirm your identity and protect your account</li>
        </ul>
        <p>At any time, you have the right to request access to or correction of your personal information. You can make such a request by contacting us by using the contact details provided in the section <a href="#review-update-delete">"HOW CAN YOU REVIEW, UPDATE, OR DELETE THE DATA WE COLLECT FROM YOU?"</a></p>
        <p>If you believe we are unlawfully processing your personal information, you have the right to submit a complaint about a breach of the Australian Privacy Principles to the <a href="https://www.oaic.gov.au/" target="_blank">Office of the Australian Information Commissioner</a> and a breach of New Zealand's Privacy Principles to the <a href="https://www.privacy.org.nz/" target="_blank">Office of New Zealand Privacy Commissioner</a>.</p>

        <h4>Republic of South Africa</h4>
        <p>At any time, you have the right to request access to or correction of your personal information. You can make such a request by contacting us by using the contact details provided in the section <a href="#review-update-delete">"HOW CAN YOU REVIEW, UPDATE, OR DELETE THE DATA WE COLLECT FROM YOU?"</a></p>
        <p>If you are unsatisfied with the manner in which we address any complaint with regard to our processing of personal information, you can contact the office of the regulator, the details of which are:</p>
        <ul>
          <li><a href="https://www.justice.gov.za/inforeg/" target="_blank">The Information Regulator (South Africa)</a></li>
          <li>General enquiries: <a href="mailto:enquiries@inforegulator.org.za">enquiries@inforegulator.org.za</a></li>
          <li>Complaints (complete POPIA/PAIA form 5): <a href="mailto:PAIAComplaints@inforegulator.org.za">PAIAComplaints@inforegulator.org.za</a> &amp; <a href="mailto:POPIAComplaints@inforegulator.org.za">POPIAComplaints@inforegulator.org.za</a></li>
        </ul>


        <!-- section 15 -->
        <h2 id="updates">15. DO WE MAKE UPDATES TO THIS NOTICE?</h2>
        <p class="in-short"><strong>In Short:</strong> Yes, we will update this notice as necessary to stay compliant with relevant laws.</p>
        <p>We may update this Privacy Notice from time to time. The updated version will be indicated by an updated "Revised" date at the top of this Privacy Notice. If we make material changes to this Privacy Notice, we may notify you either by prominently posting a notice of such changes or by directly sending you a notification. We encourage you to review this Privacy Notice frequently to be informed of how we are protecting your information.</p>

        <!-- section 16 -->
        <h2 id="contact">16. HOW CAN YOU CONTACT US ABOUT THIS NOTICE?</h2>
        <p>If you have questions or comments about this notice, you may email us at  MUSA_POLICY@MUSA.ART or contact us by post at:</p>
        <address>
          Never Ending Memory LLC<br />
          3614 US HWY 87<br />
          Sheridan, WY 82801<br />
          United States<br />
        </address>

        <!-- section 17 -->
        <h2 id="review-update-delete">17. HOW CAN YOU REVIEW, UPDATE, OR DELETE THE DATA WE COLLECT FROM YOU?</h2>
        <p>Based on the applicable laws of your country or state of residence in the US, you may have the right to request access to the personal information we collect from you, details about how we have processed it, correct inaccuracies, or delete your personal information. You may also have the right to withdraw your consent to our processing of your personal information. These rights may be limited in some circumstances by applicable law. To request to review, update, or delete your personal information, please fill out and submit a <a href="#" target="_blank">data subject access request</a>.</p>
    </body>
    </html>
    ''';
  }
}
