(() => {
  "use strict";

  const config = window.TRIVOSH_CONFIG || {};
  const $ = id => document.getElementById(id);

  const configured =
    window.supabase &&
    config.supabaseUrl &&
    !config.supabaseUrl.includes("PASTE_") &&
    config.supabaseAnonKey &&
    !config.supabaseAnonKey.includes("PASTE_");

  if (!configured) {
    $("loginMessage").textContent =
      "Supabase configuration पूरी नहीं है। config.js जाँचें।";
    $("loginBtn").disabled = true;
    return;
  }

  const db = window.supabase.createClient(
    config.supabaseUrl,
    config.supabaseAnonKey
  );

  function message(id, text) {
    $(id).textContent = text;
  }

  async function checkLogin() {
    const { data } = await db.auth.getSession();
    const session = data.session;

    if (!session) {
      $("loginBox").classList.remove("hidden");
      $("adminBox").classList.add("hidden");
      return;
    }

    // केवल तय किए गए मालिक के UID को अनुमति दें।
    if (!config.adminUserId ||
        session.user.id !== config.adminUserId) {
      await db.auth.signOut();
      message("loginMessage", "इस अकाउंट को Admin की अनुमति नहीं है।");
      return;
    }

    $("loginBox").classList.add("hidden");
    $("adminBox").classList.remove("hidden");
    await loadProducts();
  }

  $("loginBtn").addEventListener("click", async () => {
    message("loginMessage", "Login हो रहा है...");
    const email = $("email").value.trim();
    const password = $("password").value;

    const { error } = await db.auth.signInWithPassword({
      email,
      password
    });

    if (error) {
      message("loginMessage", "Login नहीं हुआ: " + error.message);
      return;
    }

    await checkLogin();
  });

  async function loadProducts() {
    const list = $("productList");
    list.textContent = "Loading...";

    const { data, error } = await db
      .from("products")
      .select("id,name,price,size,image_url,description,active")
      .order("name");

    if (error) {
      list.textContent =
        "Products नहीं दिखे। Supabase products table और permissions जाँचें: " +
        error.message;
      return;
    }

    list.replaceChildren();

    if (!data || data.length === 0) {
      list.textContent = "अभी कोई product नहीं है।";
      return;
    }

    data.forEach(product => {
      const item = document.createElement("div");
      item.className = "item";

      const title = document.createElement("strong");
      title.textContent = product.name || "Unnamed product";

      const details = document.createElement("p");
      details.textContent =
        "₹" + product.price + " | " + (product.size || "");

      const edit = document.createElement("button");
      edit.textContent = "Edit name / price";
      edit.addEventListener("click", async () => {
        const name = prompt("Product name:", product.name || "");
        if (name === null) return;
        const priceText = prompt("Price ₹:", String(product.price ?? ""));
        if (priceText === null) return;

        const price = Number(priceText);
        if (!name.trim() || !Number.isFinite(price) || price < 0) {
          alert("Product name और सही price डालें।");
          return;
        }

        const { error } = await db.from("products")
          .update({ name: name.trim(), price })
          .eq("id", product.id);

        if (error) {
          alert("Update नहीं हुआ: " + error.message);
          return;
        }

        await loadProducts();
      });

      const toggle = document.createElement("button");
      toggle.textContent = product.active === false
        ? "Show product"
        : "Hide product";

      toggle.addEventListener("click", async () => {
        const { error } = await db.from("products")
          .update({ active: product.active === false })
          .eq("id", product.id);

        if (error) {
          alert("बदलाव नहीं हुआ: " + error.message);
          return;
        }
        await loadProducts();
      });

      item.append(title, details, edit, toggle);
      list.appendChild(item);
    });
  }

  $("addProductBtn").addEventListener("click", async () => {
    const name = $("productName").value.trim();
    const price = Number($("productPrice").value);

    if (!name || $("productPrice").value === "" ||
        !Number.isFinite(price) || price < 0) {
      message("adminMessage", "Product name और सही price डालें।");
      return;
    }

    const product = {
      name,
      price,
      size: $("productSize").value.trim(),
      image_url: $("productImage").value.trim(),
      description: $("productDescription").value.trim(),
      active: true
    };

    const { error } = await db.from("products").insert(product);

    if (error) {
      message("adminMessage", "Product add नहीं हुआ: " + error.message);
      return;
    }

    message("adminMessage", "Product add हो गया।");
    ["productName", "productPrice", "productSize",
     "productImage", "productDescription"]
      .forEach(id => $(id).value = "");

    await loadProducts();
  });

  $("logoutBtn").addEventListener("click", async () => {
    await db.auth.signOut();
    location.reload();
  });

  db.auth.onAuthStateChange(() => {
    setTimeout(checkLogin, 0);
  });

  checkLogin();
})();
