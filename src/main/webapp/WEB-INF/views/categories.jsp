<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Shop – FreshCart</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
  <style>
    /* ── Page background ── */
    body {
      background-image: url('${pageContext.request.contextPath}/static/img/grocery-bg.jpg');
      background-size: cover;
      background-position: center;
      background-attachment: fixed;
      background-color: #0d3b1f;
    }
    body::before {
      content: '';
      position: fixed; inset: 0;
      background: rgba(0,0,0,0.50);
      z-index: 0; pointer-events: none;
    }
    body > * { position: relative; z-index: 1; }

    /* ── Hero ── */
    .shop-hero {
      text-align: center;
      padding: 3rem 1.5rem 1.75rem;
      color: white;
      animation: fadeInDown 0.7s ease;
    }
    .shop-hero-badge {
      display: inline-block;
      background: rgba(255,213,79,0.2);
      border: 1px solid rgba(255,213,79,0.5);
      color: #ffd54f;
      font-size: 0.78rem; font-weight: 800;
      padding: 0.28rem 1rem; border-radius: 20px;
      margin-bottom: 0.9rem;
      letter-spacing: 1px; text-transform: uppercase;
    }
    .shop-hero h1 {
      font-family: 'Poppins', sans-serif;
      font-size: 2.9rem; font-weight: 800; line-height: 1.12;
      text-shadow: 0 4px 24px rgba(0,0,0,0.4);
      margin-bottom: 0.6rem;
    }
    .shop-hero h1 span { color: #ffd54f; }
    .shop-hero p {
      font-size: 1rem; opacity: 0.88; font-weight: 600;
      text-shadow: 0 1px 8px rgba(0,0,0,0.4);
    }
    .shop-search {
      max-width: 460px; margin: 1.4rem auto 0;
      display: flex;
      background: rgba(255,255,255,0.96);
      border-radius: 50px; overflow: hidden;
      box-shadow: 0 8px 32px rgba(0,0,0,0.28);
      animation: scaleIn 0.5s ease 0.3s both;
    }
    .shop-search input {
      flex: 1; border: none; background: transparent;
      padding: 0.82rem 1.2rem;
      font-family: 'Nunito', sans-serif; font-size: 0.93rem; font-weight: 600;
      color: var(--text-dark);
    }
    .shop-search input:focus { outline: none; }
    .shop-search button {
      padding: 0.72rem 1.4rem;
      background: linear-gradient(135deg, var(--green-dark), var(--green-mid));
      border: none; color: white; font-weight: 800; font-size: 0.88rem;
      cursor: pointer; font-family: 'Nunito', sans-serif; transition: all 0.2s;
    }
    .shop-search button:hover { background: var(--green-dark); }

    .shop-stats {
      display: flex; justify-content: center; gap: 2rem;
      padding: 0.9rem 1.5rem;
      color: rgba(255,255,255,0.78);
      font-size: 0.83rem; font-weight: 700;
    }
    .shop-stat { display: flex; align-items: center; gap: 0.4rem; }
    .shop-stat-dot { width: 6px; height: 6px; border-radius: 50%; background: #ffd54f; }

    .section-label {
      text-align: center;
      color: rgba(255,255,255,0.55);
      font-size: 0.72rem; font-weight: 800;
      letter-spacing: 2px; text-transform: uppercase;
      margin: 0 1.5rem 0.7rem;
    }

    /* ── COLORFUL CATEGORY TILES — solid gradient only, no image ── */
    .category-card {
      position: relative;
      border: none !important;
      overflow: hidden;
    }

    /* Per-category solid gradient background */
    .cat-fruits   { background: linear-gradient(160deg, #e65100, #ff8f00) !important; }
    .cat-veg      { background: linear-gradient(160deg, #1b5e20, #388e3c) !important; }
    .cat-meat     { background: linear-gradient(160deg, #b71c1c, #e53935) !important; }
    .cat-dairy    { background: linear-gradient(160deg, #01579b, #039be5) !important; }
    .cat-bakery   { background: linear-gradient(160deg, #e65100, #ffa000) !important; }
    .cat-staple   { background: linear-gradient(160deg, #4a148c, #8e24aa) !important; }
    .cat-beverage { background: linear-gradient(160deg, #006064, #00acc1) !important; }
    .cat-frozen   { background: linear-gradient(160deg, #1565c0, #42a5f5) !important; }

    /* All inner content sits above the overlay */
    .category-card > * { position: relative; z-index: 1; }

    /* Make text white on all coloured tiles */
    .category-name  { color: #ffffff !important; font-size: 1rem !important; font-weight: 900 !important; text-shadow: 0 2px 8px rgba(0,0,0,0.3); }
    .category-count { color: rgba(255,255,255,0.82) !important; font-weight: 700 !important; text-shadow: 0 1px 4px rgba(0,0,0,0.3); }
    .category-arrow { background: rgba(255,255,255,0.22) !important; color: #fff !important; border: 1px solid rgba(255,255,255,0.3); }
    .category-card:hover .category-arrow { background: rgba(255,255,255,0.40) !important; transform: translateX(4px); }

    /* Icon wraps become semi-transparent white bubbles */
    .category-icon-wrap {
      background: rgba(255,255,255,0.20) !important;
      backdrop-filter: blur(6px);
      border: 1px solid rgba(255,255,255,0.3);
      width: 72px !important; height: 72px !important;
      border-radius: 20px !important;
      font-size: 2.2rem !important;
      box-shadow: 0 4px 16px rgba(0,0,0,0.15);
    }

    /* Stronger hover effect */
    .category-card:hover {
      transform: translateY(-10px) scale(1.04) !important;
      box-shadow: 0 24px 56px rgba(0,0,0,0.35) !important;
    }
  </style>
</head>
<body>
<jsp:include page="navbar.jsp"/>

<!-- Hero -->
<div class="shop-hero">
  <div class="shop-hero-badge">🌿 100% Fresh Guaranteed</div>
  <h1>Shop Fresh,<br>Live <span>Healthy</span></h1>
  <p>8 categories of farm-fresh groceries delivered to your doorstep</p>
  <form class="shop-search" action="${pageContext.request.contextPath}/shop/products" method="get">
    <input type="text" name="search" placeholder="Search for fruits, vegetables, milk...">
    <button type="submit">🔍 Search</button>
  </form>
</div>

<div class="shop-stats">
  <div class="shop-stat"><div class="shop-stat-dot"></div>500+ Products</div>
  <div class="shop-stat"><div class="shop-stat-dot"></div>8 Categories</div>
  <div class="shop-stat"><div class="shop-stat-dot"></div>Same-day Delivery</div>
  <div class="shop-stat"><div class="shop-stat-dot"></div>Fresh Daily</div>
</div>

<!-- Deals Banner -->
<div class="deals-banner">
  <div>
    <h3>🏷️ Near-Expiry Flash Deals — Up to 50% OFF!</h3>
    <p>Limited time offer on fresh items closing to expiry. Grab them before they're gone!</p>
  </div>
  <a href="${pageContext.request.contextPath}/shop/clearance" class="btn btn-lg">View Deals →</a>
</div>

<!-- Category Grid 4 × 2 -->
<div class="section-label">Browse Categories</div>
<div class="category-grid-wrapper">
  <div class="category-grid stagger">

    <!-- ROW 1 -->
    <a href="${pageContext.request.contextPath}/shop/products?category=Fruits"
       class="category-card cat-fruits anim-up">
      <div class="category-icon-wrap">🍎</div>
      <div class="category-name">Fruits</div>
      <div class="category-count">Tropical &amp; seasonal</div>
      <div class="category-arrow">→</div>
    </a>

    <a href="${pageContext.request.contextPath}/shop/products?category=Vegetables"
       class="category-card cat-veg anim-up">
      <div class="category-icon-wrap">🥦</div>
      <div class="category-name">Vegetables</div>
      <div class="category-count">Farm-fresh daily</div>
      <div class="category-arrow">→</div>
    </a>

    <a href="${pageContext.request.contextPath}/shop/products?category=Meat"
       class="category-card cat-meat anim-up">
      <div class="category-icon-wrap">🥩</div>
      <div class="category-name">Meat</div>
      <div class="category-count">Premium quality cuts</div>
      <div class="category-arrow">→</div>
    </a>

    <a href="${pageContext.request.contextPath}/shop/products?category=Dairy"
       class="category-card cat-dairy anim-up">
      <div class="category-icon-wrap">🥛</div>
      <div class="category-name">Dairy</div>
      <div class="category-count">Milk, curd &amp; more</div>
      <div class="category-arrow">→</div>
    </a>

    <!-- ROW 2 -->
    <a href="${pageContext.request.contextPath}/shop/products?category=Bakery"
       class="category-card cat-bakery anim-up">
      <div class="category-icon-wrap">🍞</div>
      <div class="category-name">Bakery</div>
      <div class="category-count">Freshly baked goods</div>
      <div class="category-arrow">→</div>
    </a>

    <a href="${pageContext.request.contextPath}/shop/products?category=Staple+Grocery"
       class="category-card cat-staple anim-up">
      <div class="category-icon-wrap">🌾</div>
      <div class="category-name">Staple Grocery</div>
      <div class="category-count">Rice, dhal &amp; essentials</div>
      <div class="category-arrow">→</div>
    </a>

    <a href="${pageContext.request.contextPath}/shop/products?category=Beverage"
       class="category-card cat-beverage anim-up">
      <div class="category-icon-wrap">🧃</div>
      <div class="category-name">Beverage</div>
      <div class="category-count">Juices, teas &amp; drinks</div>
      <div class="category-arrow">→</div>
    </a>

    <a href="${pageContext.request.contextPath}/shop/products?category=Frozen"
       class="category-card cat-frozen anim-up">
      <div class="category-icon-wrap">🧊</div>
      <div class="category-name">Frozen</div>
      <div class="category-count">Ice cream &amp; frozen meals</div>
      <div class="category-arrow">→</div>
    </a>

  </div>
</div>

<!-- spacer — no footer text -->
<div style="height:2rem;"></div>

<script src="${pageContext.request.contextPath}/static/js/main.js"></script>
</body>
</html>
