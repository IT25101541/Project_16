/* FreshCart – Enhanced JS v2 */

// ── PAGE LOAD ANIMATION ──────────────────────────────
document.addEventListener('DOMContentLoaded', function () {

  // Animate elements on scroll using IntersectionObserver
  const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.style.animationPlayState = 'running';
        observer.unobserve(entry.target);
      }
    });
  }, { threshold: 0.1 });

  document.querySelectorAll('.anim-up, .anim-scale, .anim-slide').forEach(el => {
    el.style.animationPlayState = 'paused';
    observer.observe(el);
  });

  // Auto-dismiss alerts after 4 seconds
  document.querySelectorAll('.alert').forEach(a => {
    setTimeout(() => {
      a.style.transition = 'all 0.5s ease';
      a.style.opacity = '0';
      a.style.transform = 'translateY(-10px)';
      setTimeout(() => a.remove(), 500);
    }, 4000);
  });

  // Qty live update on cart page
  document.querySelectorAll('.qty-update').forEach(function (input) {
    input.addEventListener('change', function () {
      this.closest('form').submit();
    });
  });

  // Navbar scroll effect
  const navbar = document.querySelector('.navbar');
  if (navbar) {
    window.addEventListener('scroll', () => {
      if (window.scrollY > 20) {
        navbar.style.boxShadow = '0 4px 30px rgba(0,0,0,0.15)';
      } else {
        navbar.style.boxShadow = '0 4px 24px rgba(0,0,0,0.09)';
      }
    });
  }

  // Button ripple effect
  document.querySelectorAll('.btn').forEach(btn => {
    btn.addEventListener('click', function (e) {
      const ripple = document.createElement('span');
      const rect = this.getBoundingClientRect();
      const size = Math.max(rect.width, rect.height);
      ripple.style.cssText = `
        position:absolute; border-radius:50%;
        width:${size}px; height:${size}px;
        left:${e.clientX - rect.left - size/2}px;
        top:${e.clientY - rect.top - size/2}px;
        background:rgba(255,255,255,0.35);
        transform:scale(0); animation:ripple 0.6s ease-out;
        pointer-events:none;
      `;
      this.style.position = 'relative';
      this.style.overflow = 'hidden';
      this.appendChild(ripple);
      setTimeout(() => ripple.remove(), 700);
    });
  });

  // Add ripple keyframe if not exists
  if (!document.getElementById('ripple-style')) {
    const style = document.createElement('style');
    style.id = 'ripple-style';
    style.textContent = `@keyframes ripple{0%{transform:scale(0);opacity:0.6}100%{transform:scale(4);opacity:0}}`;
    document.head.appendChild(style);
  }
});

// ── QTY STEPPER ──────────────────────────────────────
function increment(inputId) {
  const el = document.getElementById(inputId);
  if (el) {
    el.value = Math.min(parseInt(el.value || 1) + 1, 99);
    el.style.transform = 'scale(1.15)';
    setTimeout(() => el.style.transform = '', 200);
  }
}

function decrement(inputId) {
  const el = document.getElementById(inputId);
  if (el) {
    el.value = Math.max(parseInt(el.value || 1) - 1, 1);
    el.style.transform = 'scale(0.88)';
    setTimeout(() => el.style.transform = '', 200);
  }
}

// ── CONFIRM DIALOGS ──────────────────────────────────
function confirmAction(msg, formId) {
  if (confirm(msg)) document.getElementById(formId).submit();
}

// ── PRINT / PDF BILL ─────────────────────────────────
function printBill() { window.print(); }

function downloadBill() {
  const btn = document.getElementById('billActions');
  if (btn) btn.style.display = 'none';
  window.print();
  if (btn) btn.style.display = '';
}

// ── DELIVERY GPS MAP ─────────────────────────────────
function initDeliveryMap(lat, lng) {
  const map = document.getElementById('deliveryMap');
  if (!map) return;
  map.innerHTML = `
    <span style="font-size:3rem;animation:float 2s ease-in-out infinite">🗺️</span>
    <p>Driver at: ${lat}, ${lng}</p>
    <p style="font-size:0.72rem;opacity:0.65">Live GPS tracking active</p>
  `;
}

// ── SMOOTH PAGE TRANSITIONS ──────────────────────────
document.addEventListener('DOMContentLoaded', function () {
  document.body.style.opacity = '0';
  document.body.style.transition = 'opacity 0.4s ease';
  requestAnimationFrame(() => {
    document.body.style.opacity = '1';
  });

  document.querySelectorAll('a:not([target="_blank"]):not([href^="#"]):not([href^="javascript"])').forEach(link => {
    link.addEventListener('click', function (e) {
      const href = this.getAttribute('href');
      if (!href || href.startsWith('mailto') || href.startsWith('tel')) return;
      e.preventDefault();
      document.body.style.opacity = '0';
      setTimeout(() => window.location.href = href, 300);
    });
  });
});
