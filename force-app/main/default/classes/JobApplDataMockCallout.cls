public with sharing class JobApplDataMockCallout implements HttpCalloutMock {
    private static String DUMMY_RESPONSE_PAYLOAD = '{"totalCount":20,"jobs":[{"title":"Drywall Business Developer: $125K-$150K","location":"Winter Park, FL","snippet":"JOB DESCRIPTION: $125K-$150K\r\n SEEKING MULTI-FAMILY & COMMERCIAL REPAINT BUSINESS <b>DEVELOPERS\r</b>\n GPAC: #1 Specialty Construction Recruiting Firm in North America: WORK FOR A LEADING CONTRACTOR\r\n I am working with a well-respected, firmly established Painting Sub-Contractor...&nbsp;","salary":"$125k - $150k","source":"logicmelon.com","type":"Full-time","link":"https://jooble.org/desc/4959076626275316199?ckey=Salesforce+Developer&rgn=0&pos=1&groupId=40906&elckey=8440538272920949176&p=1&aq=6962400891304330187&cid=3503&jobAge=17&relb=100&brelb=100&bscr=2566.7678&scr=2566.7678","company":"Gpac","updated":"2024-06-10T12:00:30.9281723+00:00","id":4959076626275316199},{"title":"Secret Cleared CRM Developer","location":"United States","snippet":"&nbsp;...Secret Cleared CRM <b>Developer </b>\r\n a0MaA0000003Cz7.1_1716231521\r\n Job Title: Secret Cleared CRM Developer \r\n Work Location: Remote \r\n Office Location: Washington, DC \r\n Salary: $150,000 USD \r\n : \r\n We are seeking a talented and experienced Microsoft Dynamics Developer with...&nbsp;","salary":"$160k - $170k","source":"nigelfrank.com","type":"","link":"https://jooble.org/desc/-3534103071757875887?ckey=Salesforce+Developer&rgn=0&pos=2&groupId=40906&elckey=8440538272920949176&p=1&aq=6962400891304330187&cid=3503&jobAge=521&relb=100&brelb=100&bscr=2531.7615&scr=2531.7615","company":"Nigel Frank","updated":"2024-05-20T00:00:00.0000000","id":-3534103071757875887},{"title":"Secret cleared Dynamics CRM Developer","location":"United States","snippet":"&nbsp;...Secret cleared Dynamics CRM <b>Developer </b>\r\n a0MaA0000002d8X.1_1715788731\r\n**Secret clearance is required to be considered**\r\n We are looking for an experienced Dynamics CRM Developer to play a key role in the design, development, customization, and integration of Microsoft...&nbsp;","salary":"$160k - $170k","source":"nigelfrank.com","type":"","link":"https://jooble.org/desc/8096542394219198012?ckey=Salesforce+Developer&rgn=0&pos=3&groupId=40906&elckey=8440538272920949176&p=1&aq=6962400891304330187&cid=3503&jobAge=641&relb=100&brelb=100&bscr=2318.3928&scr=2318.3928","company":"Nigel Frank","updated":"2024-05-15T00:00:00.0000000","id":8096542394219198012},{"title":"Senior SharePoint Developer","location":"United States","snippet":"&nbsp;...Senior SharePoint <b>Developer </b>\r\n4/3/24_1712150745\r\n Senior SharePoint Developer - Hybrid role \r\n A leading international law firm specializes in innovative legal solutions for top financial institutions and Fortune Global 500 companies across Asia, Europe, Latin America,...&nbsp;","salary":"$160k - $170k","source":"nigelfrank.com","type":"","link":"https://jooble.org/desc/-6364821059790132119?ckey=Salesforce+Developer&rgn=0&pos=4&groupId=40906&elckey=8440538272920949176&p=1&aq=6962400891304330187&cid=3503&jobAge=1649&relb=100&brelb=100&bscr=2287.4568&scr=2287.4568","company":"Nigel Frank","updated":"2024-04-03T00:00:00.0000000","id":-6364821059790132119},{"title":"D365 F+O Developer-Orangburg, NY-$185,000","location":"United States","snippet":"&nbsp;...D365 F+O <b>Developer-</b>Orangburg, NY-$185,000\r\n CC12182023_1717006034\r\n D365 F&O Project Lead \r\n On site in Orangeburg, NY \r\n$185,000\r\n Our client is women and family owned manufacturer of plastics bags. They are a leader in their industry and are currently in the beginning...&nbsp;","salary":"$150k - $185k","source":"nigelfrank.com","type":"","link":"https://jooble.org/desc/8810533938416890379?ckey=Salesforce+Developer&rgn=0&pos=5&groupId=40906&elckey=8440538272920949176&p=1&aq=6962400891304330187&cid=3503&jobAge=305&relb=100&brelb=100&bscr=2154.9556&scr=2154.9556","company":"Nigel Frank","updated":"2024-05-29T00:00:00.0000000","id":8810533938416890379},{"title":"D365 Business Central Developer - Remote (USA) - $125k","location":"United States","snippet":"&nbsp;...D365 Business Central <b>Developer </b>- Remote (USA) - $125k \r\n a0MaA0000002L1xUAE_1714596562\r\n Business Central Developer - Remote (USA) - $125k - Remote \r\n One of our top clients, a Microsoft Partner who handles both Dynamics implementations and ISV integrations, is seeking...&nbsp;","salary":"$120k - $125k","source":"nigelfrank.com","type":"","link":"https://jooble.org/desc/-612532334677135884?ckey=Salesforce+Developer&rgn=0&pos=6&groupId=40906&elckey=8440538272920949176&p=1&aq=6962400891304330187&cid=3503&jobAge=977&relb=100&brelb=100&bscr=1980.8423&scr=1980.8423","company":"Nigel Frank","updated":"2024-05-01T00:00:00.0000000","id":-612532334677135884},{"title":"Business Applications Developer - Rosemont, IL - $150k","location":"United States","snippet":"&nbsp;...Business Applications <b>Developer </b>- Rosemont, IL - $150k \r\n a0MaA0000001twvUAA_1713822631\r\n Business Applications Developer - Rosemont, IL - $150k \r\n Our client is seeking a Senior Business Applications Developer to play a key role in designing, implementing, and upgrading...&nbsp;","salary":"$140k - $151k","source":"nigelfrank.com","type":"","link":"https://jooble.org/desc/3050007471992792953?ckey=Salesforce+Developer&rgn=0&pos=7&groupId=40906&elckey=8440538272920949176&p=1&aq=6962400891304330187&cid=3503&jobAge=1193&relb=100&brelb=100&bscr=1909.0667&scr=1909.0667","company":"Nigel Frank","updated":"2024-04-22T00:00:00.0000000","id":3050007471992792953},{"title":"Sr. Business Central Developer - Denver/Hybrid - $145k","location":"United States","snippet":"&nbsp;...Sr. Business Central <b>Developer </b>- Denver/Hybrid - $145k \r\n a0MaA0000000DrhUAE_1710801630\r\n Sr. Business Central Developer - Denver/Hybrid - $145k \r\n Are you an experienced Business Central Developer looking to make an impact in a growing organization?\r\n My client is a Business...&nbsp;","salary":"$135k - $145k","source":"nigelfrank.com","type":"","link":"https://jooble.org/desc/-6375540747879181423?ckey=Salesforce+Developer&rgn=0&pos=8&groupId=40906&elckey=8440538272920949176&p=1&aq=6962400891304330187&cid=3503&jobAge=2033&relb=100&brelb=100&bscr=1809.708&scr=1809.708","company":"Nigel Frank","updated":"2024-03-18T00:00:00.0000000","id":-6375540747879181423},{"title":"Full Stack Developer - Top Secret needed - Hybrid role!","location":"United States","snippet":"&nbsp;...Full Stack <b>Developer </b>- Top Secret needed - Hybrid role!\r\n3/13/AP_1710332995\r\n**Active Top Secret required**\r\n Seeking a Software Developer responsible for end-to-end software lifecycle management, including requirements analysis, development, testing, deployment, monitoring...&nbsp;","salary":"$177k - $187k","source":"nigelfrank.com","type":"","link":"https://jooble.org/desc/3794964513228496400?ckey=Salesforce+Developer&rgn=0&pos=9&groupId=40906&elckey=8440538272920949176&p=1&aq=6962400891304330187&cid=3503&jobAge=2153&relb=100&brelb=100&bscr=1662.3954&scr=1662.3954","company":"Nigel Frank","updated":"2024-03-13T00:00:00.0000000","id":3794964513228496400},{"title":"Power BI Developer Data Analyst-Orlando, FL-$120k","location":"United States","snippet":"&nbsp;...Power BI <b>Developer </b>Data Analyst-Orlando, FL-$120k \r\n CC03152024_1713209103\r\n Power BI Developer Data Analyst \r\n Hybrid Schedule in Lake Mary \r\n$120k-130k+ bonus potential \r\n Our client is in the food manufacturing industry and have recently made multiple acquisitions....&nbsp;","salary":"$120k - $130k","source":"nigelfrank.com","type":"","link":"https://jooble.org/desc/-3635697411983074708?ckey=Salesforce+Developer&rgn=0&pos=10&groupId=40906&elckey=8440538272920949176&p=1&aq=6962400891304330187&cid=3503&jobAge=1361&relb=100&brelb=100&bscr=1661.2617&scr=1661.2617","company":"Nigel Frank","updated":"2024-04-15T00:00:00.0000000","id":-3635697411983074708},{"title":"Sr. D365 F&O Developer w/ MSFT VAR Exp. - $145k - Remote","location":"United States","snippet":"&nbsp;...Sr. D365 F&O <b>Developer </b>w/ MSFT VAR Exp. - $145k - Remote \r\n a0MaA0000000SQvUAM_1711054839\r\n D365 F&O Developer - Remote (EST/CST) - $145k+Unlimited PTO \r\n Our client is a well-established, mid-sized Microsoft Partner who is ambitiously growing their Dynamics 365 practice...&nbsp;","salary":"$145k - $150k","source":"nigelfrank.com","type":"","link":"https://jooble.org/desc/4693990861257094814?ckey=Salesforce+Developer&rgn=0&pos=11&groupId=40906&elckey=8440538272920949176&p=1&aq=6962400891304330187&cid=3503&jobAge=1961&relb=100&brelb=100&bscr=1412.1748&scr=1412.1748","company":"Nigel Frank","updated":"2024-03-21T00:00:00.0000000","id":4693990861257094814},{"title":"Direct Sales Representative","location":"Maryville, TN","snippet":"&nbsp;...from 5 to 50+. Core Responsibilities: Utilize our customized <b>Salesforce </b>CRM to curate leads and generate clients while expanding your...&nbsp;&nbsp;...your sales manager and team Personally visit new businesses, <b>develop </b>relationships with local business owners, follow up on referral...&nbsp;","salary":"$122k","source":"acquiretm.com","type":"Full-time","link":"https://jooble.org/desc/8329232452392905523?ckey=Salesforce+Developer&rgn=0&pos=12&groupId=40906&elckey=8440538272920949176&p=1&aq=6962400891304330187&cid=3503&jobAge=17&relb=100&brelb=100&bscr=747.5195&scr=747.5195","company":"Alleviation Enterprise LLC","updated":"2024-06-10T05:05:40.4683627+00:00","id":8329232452392905523},{"title":"Territory Sales Representative","location":"Deer Park, TX","snippet":"&nbsp;...your territory. Core Responsibilities: Utilize our customized <b>Salesforce </b>CRM to curate leads and generate clients while expanding your...&nbsp;&nbsp;...your sales manager and team Personally visit new businesses, <b>develop </b>relationships with local business owners, follow up on referral...&nbsp;","salary":"$122k","source":"acquiretm.com","type":"Full-time","link":"https://jooble.org/desc/-4705491678482209924?ckey=Salesforce+Developer&rgn=0&pos=13&groupId=40906&elckey=8440538272920949176&p=1&aq=6962400891304330187&cid=3503&jobAge=41&relb=100&brelb=100&bscr=746.61725&scr=746.61725","company":"Alleviation Enterprise LLC","updated":"2024-06-09T11:05:06.4638975+00:00","id":-4705491678482209924},{"title":"Insurance Sales Agent","location":"Cleburne, TX","snippet":"&nbsp;...50+ employees. Core Responsibilities: Utilize our customized <b>Salesforce </b>CRM to curate leads and generate clients while expanding your...&nbsp;&nbsp;...your sales manager and team Personally visit new businesses, <b>develop </b>relationships with local business owners, follow up on referral...&nbsp;","salary":"$122k","source":"acquiretm.com","type":"Full-time","link":"https://jooble.org/desc/7829721780536394604?ckey=Salesforce+Developer&rgn=0&pos=14&groupId=40906&elckey=8440538272920949176&p=1&aq=6962400891304330187&cid=3503&jobAge=41&relb=100&brelb=100&bscr=744.80975&scr=744.80975","company":"Alleviation Enterprise LLC","updated":"2024-06-09T11:05:06.8429816+00:00","id":7829721780536394604},{"title":"Chief Information Officer","location":"Reston, VA","snippet":"&nbsp;...a compelling, achievable vision for the CIO organization. \r\n <b>Developing </b>and enforcing IT best practices across the organization \r\n Ensuring...&nbsp;&nbsp;...service providers, specifically Microsoft, AWS, ServiceNow, <b>Salesforce,</b> UKG preferred. \r\n Overview: Noblis and our wholly owned...&nbsp;","salary":"$240k","source":"us.edajobs.com","type":"Full-time","link":"https://jooble.org/desc/-1079347711667962023?ckey=Salesforce+Developer&rgn=0&pos=15&groupId=40906&elckey=8440538272920949176&p=1&aq=6962400891304330187&cid=3503&jobAge=17&relb=100&brelb=100&bscr=739.59454&scr=739.5945399999999","company":"Noblis","updated":"2024-06-10T00:00:00.0000000","id":-1079347711667962023},{"title":"Director of Content and Product Marketing","location":"Washington DC","snippet":"&nbsp;...Content Marketing: \r\n Collaborate with research analysts to <b>develop </b>compelling product marketing assets, including white papers, articles...&nbsp;&nbsp;.... \r\n Experience with CRM and marketing automation software (<b>Salesforce </b>and Marketo preferred). \r\n Commitment to promoting diversity...&nbsp;","salary":"$120k","source":"us.edajobs.com","type":"Full-time","link":"https://jooble.org/desc/4945997649918086467?ckey=Salesforce+Developer&rgn=0&pos=16&groupId=40906&elckey=8440538272920949176&p=1&aq=6962400891304330187&cid=3503&jobAge=17&relb=100&brelb=100&bscr=698.04333&scr=698.04333","company":"National Journal","updated":"2024-06-10T00:00:00.0000000","id":4945997649918086467},{"title":"Sales Leader","location":"Shelton, WA","snippet":"&nbsp;...assessing their needs, and presenting customized insurance solutions that genuinely enrich their lives. Utilizing our cutting-edge <b>Salesforce </b>CRM, you will engage potential clients through a combination of cold calls and face-to-face interactions. Your aim is not just to...&nbsp;","salary":"$130k","source":"acquiretm.com","type":"Full-time","link":"https://jooble.org/desc/-4248487486061966467?ckey=Salesforce+Developer&rgn=0&pos=17&groupId=40906&elckey=8440538272920949176&p=1&aq=6962400891304330187&cid=3503&jobAge=17&relb=100&brelb=100&bscr=565.6005&scr=565.6005","company":"Summit Business Group","updated":"2024-06-10T05:05:42.3050912+00:00","id":-4248487486061966467},{"title":"Physician Assistant or Nurse Practitioner - Emergency - Per Diem","location":"Santa Monica, CA","snippet":"&nbsp;...clinical skills \r\n Tech savvy with the ability to use and or learn our systems including but not limited to Slack, Athena Health, <b>Salesforce </b>and Humanity etc. \r\n Superb technical skills, including phlebotomy, peripheral IV placement, medication administration \r\n Ability...&nbsp;","salary":"$85 - $93 per hour","source":"easyhiring_indeed","type":"Temporary","link":"https://jooble.org/desc/8378547725570002082?ckey=Salesforce+Developer&rgn=0&pos=18&groupId=40906&elckey=8440538272920949176&p=1&aq=6962400891304330187&cid=3503&jobAge=17&relb=128&brelb=115&bscr=445.0383&scr=495.34697739130434","company":"Sollis Health","updated":"2024-06-10T08:47:25.3737276+00:00","id":8378547725570002082},{"title":"ERP Manager - NAV/BC - Newark, NJ - $145k","location":"United States","snippet":"&nbsp;...it the most. \r\n Your New Role: \r\n * Manage the current application ecosystem, including but not limited to: Business Central ERP, <b>Salesforce,</b> ADP, and reporting systems such as Power BI \r\n * Lead the upgrade from NAV to BC \r\n * Act as the hands-on functional lead for...&nbsp;","salary":"$132k","source":"nigelfrank.com","type":"","link":"https://jooble.org/desc/698360531113229192?ckey=Salesforce+Developer&rgn=0&pos=19&groupId=40906&elckey=8440538272920949176&p=1&aq=6962400891304330187&cid=3503&jobAge=281&relb=100&brelb=100&bscr=398.27228&scr=398.27228","company":"Nigel Frank","updated":"2024-05-30T00:00:00.0000000","id":698360531113229192},{"title":"Dental Hygienist","location":"Lakewood, WA","snippet":"&nbsp;...total comp in the range of $75+ per hour \r\n This position is open to full or part time candidates. For part time candidate, we can <b>develop </b>a schedule that is customized to your availability. \r\n \r\n At Gentle Dental, we value our teammate’s smile as much as our patient’s...&nbsp;","salary":"$75 per hour","source":"appcast.apply.com","type":"Part-time","link":"https://jooble.org/desc/1640485872768332915?ckey=Salesforce+Developer&rgn=0&pos=20&groupId=40906&elckey=8440538272920949176&p=1&aq=6962400891304330187&cid=3503&jobAge=17&relb=175&brelb=115&bscr=251.97197&scr=383.4356065217391","company":"Gentle Dental","updated":"2024-06-10T00:00:00.0000000","id":1640485872768332915}]}';

    public HttpResponse respond(HttpRequest request) {
		// Create a fake response
		HttpResponse response = new HttpResponse();
		response.setHeader('Content-Type', 'application/json');

		// Check if the request is a POST request
		if (request.getMethod() == 'POST') {
			// Return a success response for the POST request
			response.setBody(DUMMY_RESPONSE_PAYLOAD);
		} 
		response.setStatusCode(200);
		return response;
    }

}