TRIVOSH WEBSITE — VERCEL + SUPABASE ADMIN + UPI/WHATSAPP
========================================================

IMPORTANT: ZIP ko extract karke IS FOLDER KI FILES GitHub repository ke ROOT mein upload/replace karein. ZIP file ko hi GitHub mein rakh dena kaafi nahi.

A. CONFIG.JS — ek baar zaroor set karein
1. GitHub repository mein config.js kholein > Edit (pencil) karein.
2. supabaseUrl mein Supabase Project URL paste karein.
3. supabaseAnonKey mein Publishable key (ya legacy anon key) paste karein. Service role/secret key KABHI nahi.
4. adminUserId mein Supabase Authentication > Users ka owner UID paste karein.
5. UPI ID aur WhatsApp number is ZIP mein pehle se set hain: ghoshiji96@axl and 919617510086. Agar badalna ho to hi edit karein.
6. Commit changes karein. NOTE: Vercel Environment Variables akelay plain HTML/JS ki config.js mein apne-aap nahi aate; is static website ke liye config.js mein values chahiye.

B. SUPABASE SQL
1. Supabase > Authentication > Users mein owner user create karein (email/password) aur UID copy karein.
2. supabase_setup.sql ko kholein. Har OWNER_AUTH_USER_UUID ko us UID se replace karein (quotes ke andar UUID rahe), phir poora SQL Supabase > SQL Editor mein run karein.
3. Agar SQL pehle placeholder UUID ke saath run kar diya tha, script ko sahi UUID ke saath dobara run karein.
4. Public website se product listing aur pending orders database se connect honge. Admin page /admin.html par owner email/password se login karein.

C. PRODUCT PHOTOS & PRICES
Admin > Add/edit product mein name, price, size, image URL, description save kar sakte hain. Image URL direct public https image link hona chahiye. Empty image URL par Trivosh placeholder dikhega.

D. PUBLISH
GitHub mein files root par upload/replace aur commit karein. Vercel connected repo se auto-deploy karega. Test: website homepage, add to cart, WhatsApp order, /admin.html login, product price edit, order list.

PAYMENT SAFETY
UPI button/QR payment initiate karta hai; website payment ko automatically verify nahi karti. Bank/UPI app mein transaction verify karne ke baad hi Admin mein order status 'paid' karein. Online card/UPI gateway auto-confirmation ke liye Razorpay (ya anya provider) merchant account aur secure server-side payment verification/webhook alag se chahiye. Customer-provided total ko final payment proof na samjhein.

SECURITY
Browser mein sirf Supabase Project URL + publishable/anon key use karein. Service-role key, passwords, OTP, UPI PIN, payment secret kabhi public config.js ya GitHub mein na daalein. Launch se pehle owner/non-owner accounts se access test karein.
