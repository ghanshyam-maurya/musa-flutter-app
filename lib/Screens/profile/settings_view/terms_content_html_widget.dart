import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html_table/flutter_html_table.dart';

class TermsContentHTMLWidget extends StatelessWidget {
  const TermsContentHTMLWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Html(
        data: _getTermsAndConditionsHtml(),
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
          ".section-title": Style(
            fontWeight: FontWeight.bold,
            margin: Margins.only(top: 16.0, bottom: 8.0),
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

  String _getTermsAndConditionsHtml() {
    return '''
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="UTF-8">
        <title>Terms and Conditions</title>
    </head>
    <body>
        <h1>TERMS AND CONDITIONS</h1>
        <p class="last-updated">Last updated January 01, 2025</p>

        <h2>AGREEMENT TO OUR LEGAL TERMS</h2>
        
        <p>We are Never Ending Memory LLC, doing business as MUSA.ART ("Company," "we," "us," "our"), a company registered in Wyoming, United States at 3614 US HWY 87, Sheridan, WY 82801. Our VAT number is TBD. We operate the website https://musa.art (the "Site"), the mobile application MUSA (the "App"), as well as any other related products and services that refer or link to these legal terms (the "Legal Terms") (collectively, the "Services").</p>

        <p>You can contact us by email at <a href="mailto:MUSA_TERMS@MUSA.ART">MUSA_TERMS@MUSA.ART</a>, or by mail to 3614 US HWY 87, Sheridan, WY 82801, United States.</p>

        <p>These Legal Terms constitute a legally binding agreement made between you, whether personally or on behalf of an entity ("you"), and Never Ending Memory LLC, concerning your access to and use of the Services. You agree that by accessing the Services, you have read, understood, and agreed to be bound by all of these Legal Terms. IF YOU DO NOT AGREE WITH ALL OF THESE LEGAL TERMS, THEN YOU ARE EXPRESSLY PROHIBITED FROM USING THE SERVICES AND YOU MUST DISCONTINUE USE IMMEDIATELY.</p>

        <p>We will provide you with prior notice of any scheduled changes to the Services you are using. The modified Legal Terms will become effective upon posting or notifying you by MUSA_TERMS@MUSA.ART, as stated in the email message. By continuing to use the Services after the effective date of any changes, you agree to be bound by the modified terms.</p>

        <p>The Services are intended for users who are at least 13 years of age. All users who are minors in the jurisdiction in which they reside (generally under the age of 18) must have the permission of, and be directly supervised by, their parent or guardian to use the Services. If you are a minor, you must have your parent or guardian read and agree to these Legal Terms prior to you using the Services.</p>

        <p>We recommend that you print a copy of these Legal Terms for your records.</p>

        <h2 id="table-of-contents">TABLE OF CONTENTS</h2>
        <ol>
            <li><a href="#our-services">OUR SERVICES</a></li>
            <li><a href="#intellectual-property">INTELLECTUAL PROPERTY RIGHTS</a></li>
            <li><a href="#user-representations">USER REPRESENTATIONS</a></li>
            <li><a href="#user-registration">USER REGISTRATION</a></li>
            <li><a href="#purchases-payment">PURCHASES AND PAYMENT</a></li>
            <li><a href="#subscriptions">SUBSCRIPTIONS</a></li>
            <li><a href="#software">SOFTWARE</a></li>
            <li><a href="#prohibited-activities">PROHIBITED ACTIVITIES</a></li>
            <li><a href="#user-contributions">USER GENERATED CONTRIBUTIONS</a></li>
            <li><a href="#contribution-license">CONTRIBUTION LICENSE</a></li>
            <li><a href="#review-guidelines">GUIDELINES FOR REVIEWS</a></li>
            <li><a href="#mobile-license">MOBILE APPLICATION LICENSE</a></li>
            <li><a href="#social-media">SOCIAL MEDIA</a></li>
            <li><a href="#third-party">THIRD-PARTY WEBSITES AND CONTENT</a></li>
            <li><a href="#advertisers">ADVERTISERS</a></li>
            <li><a href="#services-management">SERVICES MANAGEMENT</a></li>
            <li><a href="#privacy-policy">PRIVACY POLICY</a></li>
            <li><a href="#term-termination">TERM AND TERMINATION</a></li>
            <li><a href="#modifications">MODIFICATIONS AND INTERRUPTIONS</a></li>
            <li><a href="#governing-law">GOVERNING LAW</a></li>
            <li><a href="#dispute-resolution">DISPUTE RESOLUTION</a></li>
            <li><a href="#corrections">CORRECTIONS</a></li>
            <li><a href="#disclaimer">DISCLAIMER</a></li>
            <li><a href="#limitations-liability">LIMITATIONS OF LIABILITY</a></li>
            <li><a href="#indemnification">INDEMNIFICATION</a></li>
            <li><a href="#user-data">USER DATA</a></li>
            <li><a href="#electronic-communications">ELECTRONIC COMMUNICATIONS, TRANSACTIONS, AND SIGNATURES</a></li>
            <li><a href="#sms-messaging">SMS TEXT MESSAGING</a></li>
            <li><a href="#california-users">CALIFORNIA USERS AND RESIDENTS</a></li>
            <li><a href="#miscellaneous">MISCELLANEOUS</a></li>
            <li><a href="#contact-us">CONTACT US</a></li>
        </ol>

        <h2 id="our-services">1. OUR SERVICES</h2>
        <p>The information provided when using the Services is not intended for distribution to or use by any person or entity in any jurisdiction or country where such distribution or use would be contrary to law or regulation or which would subject us to any registration requirement within such jurisdiction or country. Accordingly, those persons who choose to access the Services from other locations do so on their own initiative and are solely responsible for compliance with local laws, if and to the extent local laws are applicable. The Services are not tailored to comply with industry-specific regulations (Health Insurance Portability and Accountability Act (HIPAA), Federal Information Security Management Act (FISMA), etc.), so if your interactions would be subjected to such laws, you may not use the Services. You may not use the Services in a way that would violate the Gramm-Leach-Bliley Act (GLBA).</p>

        <h2 id="intellectual-property">2. INTELLECTUAL PROPERTY RIGHTS</h2>
        <h3>Our intellectual property</h3>
        <p>We are the owner or the licensee of all intellectual property rights in our Services, including all source code, databases, functionality, software, website designs, audio, video, text, photographs, and graphics in the Services (collectively, the "Content"), as well as the trademarks, service marks, and logos contained therein (the "Marks"). Our Content and Marks are protected by copyright and trademark laws (and various other intellectual property rights and unfair competition laws) and treaties in the United States and around the world. The Content and Marks are provided in or through the Services "AS IS" for your personal, non-commercial use or internal business purpose only.</p>

        <h3>Your use of our Services</h3>
        <p>Subject to your compliance with these Legal Terms, including the "PROHIBITED ACTIVITIES" section below, we grant you a non-exclusive, non-transferable, revocable license to:</p>
        <ul>
            <li>access the Services; and</li>
            <li>download or print a copy of any portion of the Content to which you have properly gained access,</li>
        </ul>
        <p>solely for your personal, non-commercial use or internal business purpose. Except as set out in this section or elsewhere in our Legal Terms, no part of the Services and no Content or Marks may be copied, reproduced, aggregated, republished, uploaded, posted, publicly displayed, encoded, translated, transmitted, distributed, sold, licensed, or otherwise exploited for any commercial purpose whatsoever, without our express prior written permission. If you wish to make any use of the Services, Content, or Marks other than as set out in this section or elsewhere in our Legal Terms, please address your request to: <a href="mailto:MUSA_TERMS@MUSA.ART">MUSA_TERMS@MUSA.ART</a>. If we ever grant you the permission to post, reproduce, or publicly display any part of our Services or Content, you must identify us as the owners or licensors of the Services, Content, or Marks and ensure that any copyright or proprietary notice appears or is visible on posting, reproducing, or displaying our Content. We reserve all rights not expressly granted to you in and to the Services, Content, and Marks. Any breach of these Intellectual Property Rights will constitute a material breach of our Legal Terms and your right to use our Services will terminate immediately.</p>

        <h3>Your submissions and contributions</h3>
        <p>Please review this section and the "PROHIBITED ACTIVITIES" section carefully prior to using our Services to understand the (a) rights you give us and (b) obligations you have when you post or upload any content through the Services.</p>
        <p><strong>Submissions:</strong> By directly sending us any question, comment, suggestion, idea, feedback, or other information about the Services ("Submissions"), you agree to assign to us all intellectual property rights in such Submission. You agree that we shall own this Submission and be entitled to its unrestricted use and dissemination for any lawful purpose, commercial or otherwise, without acknowledgment or compensation to you.</p>
        <p><strong>Contributions:</strong> The Services may invite you to chat, contribute to, or participate in blogs, message boards, online forums, and other functionality during which you may create, submit, post, display, transmit, publish, distribute, or broadcast content and materials to us or through the Services, including but not limited to text, writings, video, audio, photographs, music, graphics, comments, reviews, rating suggestions, personal information, or other material ("Contributions"). Any Submission that is publicly posted shall also be treated as a Contribution. You understand that Contributions may be viewable by other users of the Services and possibly through third-party websites.</p>
        <p><strong>When you post Contributions, you grant us a license (including use of your name, trademarks, and logos):</strong> By posting any Contributions, you grant us an unrestricted, unlimited, irrevocable, perpetual, non-exclusive, transferable, royalty-free, fully-paid, worldwide right, and license to: use, copy, reproduce, distribute, sell, resell, publish, broadcast, retitle, store, publicly perform, publicly display, reformat, translate, excerpt (in whole or in part), and exploit your Contributions (including, without limitation, your image, name, and voice) for any purpose, commercial, advertising, or otherwise, to prepare derivative works of, or incorporate into other works, your Contributions, and to sublicense the licenses granted in this section. Our use and distribution may occur in any media formats and through any media channels. This license includes our use of your name, company name, and franchise name, as applicable, and any of the trademarks, service marks, trade names, logos, and personal and commercial images you provide.</p>
        <p><strong>You are responsible for what you post or upload:</strong> By sending us Submissions and/or posting Contributions through any part of the Services or making Contributions accessible through the Services by linking your account through the Services to any of your social networking accounts, you:</p>
        <ul>
            <li>confirm that you have read and agree with our "PROHIBITED ACTIVITIES" and will not post, send, publish, upload, or transmit through the Services any Submission nor post any Contribution that is illegal, harassing, hateful, harmful, defamatory, obscene, bullying, abusive, discriminatory, threatening to any person or group, sexually explicit, false, inaccurate, deceitful, or misleading;</li>
            <li>to the extent permissible by applicable law, waive any and all moral rights to any such Submission and/or Contribution;</li>
            <li>warrant that any such Submission and/or Contributions are original to you or that you have the necessary rights and licenses to submit such Submissions and/or Contributions and that you have full authority to grant us the above-mentioned rights in relation to your Submissions and/or Contributions; and</li>
            <li>warrant and represent that your Submissions and/or Contributions do not constitute confidential information.</li>
        </ul>
        <p>You are solely responsible for your Submissions and/or Contributions and you expressly agree to reimburse us for any and all losses that we may suffer because of your breach of (a) this section, (b) any third party's intellectual property rights, or (c) applicable law.</p>
        <p><strong>We may remove or edit your Content:</strong> Although we have no obligation to monitor any Contributions, we shall have the right to remove or edit any Contributions at any time without notice if in our reasonable opinion we consider such Contributions harmful or in breach of these Legal Terms. If we remove or edit any such Contributions, we may also suspend or disable your account and report you to the authorities.</p>

        <h2 id="user-representations">3. USER REPRESENTATIONS</h2>
        <p>By using the Services, you represent and warrant that:</p>
        <ol>
            <li>all registration information you submit will be true, accurate, current, and complete;</li>
            <li>you will maintain the accuracy of such information and promptly update such registration information as necessary;</li>
            <li>you have the legal capacity and you agree to comply with these Legal Terms;</li>
            <li>you are not under the age of 13;</li>
            <li>you are not a minor in the jurisdiction in which you reside, or if a minor, you have received parental permission to use the Services;</li>
            <li>you will not access the Services through automated or non-human means, whether through a bot, script or otherwise;</li>
            <li>you will not use the Services for any illegal or unauthorized purpose;</li>
            <li>your use of the Services will not violate any applicable law or regulation.</li>
        </ol>
        <p>If you provide any information that is untrue, inaccurate, not current, or incomplete, we have the right to suspend or terminate your account and refuse any and all current or future use of the Services (or any portion thereof).</p>

        <h2 id="user-registration">4. USER REGISTRATION</h2>
        <p>You may be required to register to use the Services. You agree to keep your password confidential and will be responsible for all use of your account and password. We reserve the right to remove, reclaim, or change a username you select if we determine, in our sole discretion, that such username is inappropriate, obscene, or otherwise objectionable.</p>

        <h2 id="purchases-payment">5. PURCHASES AND PAYMENT</h2>
        <p>We accept the following forms of payment:</p>
        <ul>
            <li>PayPal</li>
        </ul>
        <p>You agree to provide current, complete, and accurate purchase and account information for all purchases made via the Services. You further agree to promptly update account and payment information, including email address, payment method, and payment card expiration date, so that we can complete your transactions and contact you as needed. Sales tax will be added to the price of purchases as deemed required by us. We may change prices at any time. All payments shall be in US dollars.</p>
        <p>You agree to pay all charges at the prices then in effect for your purchases and any applicable shipping fees, and you authorize us to charge your chosen payment provider for any such amounts upon placing your order. We reserve the right to correct any errors or mistakes in pricing, even if we have already requested or received payment.</p>
        <p>We reserve the right to refuse any order placed through the Services. We may, in our sole discretion, limit or cancel quantities purchased per person, per household, or per order. These restrictions may include orders placed by or under the same customer account, the same payment method, and/or orders that use the same billing or shipping address. We reserve the right to limit or prohibit orders that, in our sole judgment, appear to be placed by dealers, resellers, or distributors.</p>

        <h2 id="subscriptions">6. SUBSCRIPTIONS</h2>
        <h3>Billing and Renewal</h3>
        <p>Your subscription will continue and automatically renew unless canceled. You consent to our charging your payment method on a recurring basis without requiring your prior approval for each recurring charge, until such time as you cancel the applicable order. The length of your billing cycle is monthly.</p>

        <h3>Free Trial</h3>
        <p>We offer a 15-day free trial to new users who register with the Services. The account will be charged according to the user's chosen subscription at the end of the free trial.</p>

        <h3>Cancellation</h3>
        <p>All purchases are non-refundable. You can cancel your subscription at any time by logging into your account. Your cancellation will take effect at the end of the current paid term. If you have any questions or are unsatisfied with our Services, please email us at <a href="mailto:MUSA_TERMS@MUSA.ART">MUSA_TERMS@MUSA.ART</a>.</p>

        <h3>Fee Changes</h3>
        <p>We may, from time to time, make changes to the subscription fee and will communicate any price changes to you in accordance with applicable law.</p>

        <h2 id="software">7. SOFTWARE</h2>
        <p>We may include software for use in connection with our Services. If such software is accompanied by an end user license agreement ("EULA"), the terms of the EULA will govern your use of the software. If such software is not accompanied by a EULA, then we grant to you a non-exclusive, revocable, personal, and non-transferable license to use such software solely in connection with our services and in accordance with these Legal Terms. Any software and any related documentation is provided "AS IS" without warranty of any kind, either express or implied, including, without limitation, the implied warranties of merchantability, fitness for a particular purpose, or non-infringement. You accept any and all risk arising out of use or performance of any software. You may not reproduce or redistribute any software except in accordance with the EULA or these Legal Terms.</p>

        <h2 id="prohibited-activities">8. PROHIBITED ACTIVITIES</h2>
        <p>You may not access or use the Services for any purpose other than that for which we make the Services available. The Services may not be used in connection with any commercial endeavors except those that are specifically endorsed or approved by us. As a user of the Services, you agree not to:</p>
        <ul>
            <li>Systematically retrieve data or other content from the Services to create or compile, directly or indirectly, a collection, compilation, database, or directory without written permission from us.</li>
            <li>Trick, defraud, or mislead us and other users, especially in any attempt to learn sensitive account information such as user passwords.</li>
            <li>Circumvent, disable, or otherwise interfere with security-related features of the Services, including features that prevent or restrict the use or copying of any Content or enforce limitations on the use of the Services and/or the Content contained therein.</li>
            <li>Disparage, tarnish, or otherwise harm, in our opinion, us and/or the Services.</li>
            <li>Use any information obtained from the Services in order to harass, abuse, or harm another person.</li>
            <li>Make improper use of our support services or submit false reports of abuse or misconduct.</li>
            <li>Use the Services in a manner inconsistent with any applicable laws or regulations.</li>
            <li>Engage in unauthorized framing of or linking to the Services.</li>
            <li>Upload or transmit (or attempt to upload or to transmit) viruses, Trojan horses, or other material, including excessive use of capital letters and spamming (continuous posting of repetitive text), that interferes with any party's uninterrupted use and enjoyment of the Services or modifies, impairs, disrupts, alters, or interferes with the use, features, functions, operation, or maintenance of the Services.</li>
            <li>Engage in any automated use of the system, such as using scripts to send comments or messages, or using any data mining, robots, or similar data gathering and extraction tools.</li>
            <li>Delete the copyright or other proprietary rights notice from any Content.</li>
            <li>Attempt to impersonate another user or person or use the username of another user.</li>
            <li>Upload or transmit (or attempt to upload or to transmit) any material that acts as a passive or active information collection or transmission mechanism, including without limitation, clear graphics interchange formats ("gifs"), 1×1 pixels, web bugs, cookies, or other similar devices (sometimes referred to as "spyware" or "passive collection mechanisms" or "pcms").</li>
            <li>Interfere with, disrupt, or create an undue burden on the Services or the networks or services connected to the Services.</li>
            <li>Harass, annoy, intimidate, or threaten any of our employees or agents engaged in providing any portion of the Services to you.</li>
            <li>Attempt to bypass any measures of the Services designed to prevent or restrict access to the Services, or any portion of the Services.</li>
            <li>Copy or adapt the Services' software, including but not limited to Flash, PHP, HTML, JavaScript, or other code.</li>
            <li>Except as permitted by applicable law, decipher, decompile, disassemble, or reverse engineer any of the software comprising or in any way making up a part of the Services.</li>
            <li>Except as may be the result of standard search engine or Internet browser usage, use, launch, develop, or distribute any automated system, including without limitation, any spider, robot, cheat utility, scraper, or offline reader that accesses the Services, or use or launch any unauthorized script or other software.</li>
            <li>Use a buying agent or purchasing agent to make purchases on the Services.</li>
            <li>Make any unauthorized use of the Services, including collecting usernames and/or email addresses of users by electronic or other means for the purpose of sending unsolicited email, or creating user accounts by automated means or under false pretenses.</li>
            <li>Use the Services as part of any effort to compete with us or otherwise use the Services and/or the Content for any revenue generating endeavor or commercial enterprise.</li>
            <li>Sell or otherwise transfer your profile.</li>
        </ul>

        <h2 id="user-contributions">9. USER GENERATED CONTRIBUTIONS</h2>
        <p>The Services may invite you to chat, contribute to, or participate in blogs, message boards, online forums, and other functionality, and may provide you with the opportunity to create, submit, post, display, transmit, perform, publish, distribute, or broadcast content and materials to us or on the Services, including but not limited to text, writings, video, audio, photographs, graphics, comments, suggestions, or personal information or other material (collectively, "Contributions"). Contributions may be viewable by other users of the Services and through third-party websites. As such, any Contributions you transmit may be treated as non-confidential and non-proprietary. When you create or make available any Contributions, you thereby represent and warrant that:</p>
        
        <h2 id="contact-us">31. CONTACT US</h2>
        <p>In order to resolve a complaint regarding the Services or to receive further information regarding use of the Services, please contact us at:</p>
        <p><strong>Never Ending Memory LLC</strong><br>
        3614 US HWY 87<br>
        Sheridan, WY 82801<br>
        United States<br>
        <a href="mailto:MUSA_TERMS@MUSA.ART">MUSA_TERMS@MUSA.ART</a></p>
    </body>
    </html>
    ''';
  }
}
