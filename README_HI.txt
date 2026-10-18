TRIVOSH WEBSITE STARTER - VERCEL + UPI QR
=========================================

Is ZIP ko extract karke is folder ke andar ki files GitHub repository ke ROOT mein upload karein. Sirf ZIP ko repository mein upload karna enough nahi; pehle extract karein.

1) Vercel static site: index.html, style.css, app.js, config.js and admin.html deploy ho sakte hain.
2) UPI QR: config.js mein apna UPI ID, payee name aur WhatsApp number update karein. Example format: 91XXXXXXXXXX. Apna actual UPI ID use karein; yahan kisi ko UPI PIN/OTP na dein.
3) UPI QR/deep link sirf payment initiate karta hai. Payment website automatically verify nahi karti. UPI/bank app mein transaction verify karne ke baad hi order ko paid mark karein.
4) Product listing abhi demo products dikhati hai. Admin.html setup guide hai; real admin login/product database ko Supabase Auth + database policies ke saath configure aur test karna zaroori hai. Is starter mein live working secured admin CRUD abhi enabled nahi hai.
5) Supabase ke liye project banayein, Authentication > Users mein owner user create karein, user UUID copy karein. supabase_setup.sql mein OWNER_AUTH_USER_UUID replace karke SQL Editor mein run karein. config.js mein project URL aur anon/publishable key set karein. Service-role/secret key browser code mein kabhi na rakhein.
6) SQL policies run karne se pehle Supabase documentation/policy configuration check karein; test with a non-owner account to ensure it cannot edit products or orders.
7) GitHub repository ke root mein extracted files upload/commit karein. Vercel connected project auto-deploy karega. Admin guide: https://YOUR-SITE.vercel.app/admin.html
8) Production launch se pehle end-to-end test karein. Checkout data is a starter demonstration and should not be treated as a trusted order/payment record until server-side validation is implemented.
