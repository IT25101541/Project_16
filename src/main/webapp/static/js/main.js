/* FreshCart – Main JS */

// ── QTY STEPPER ─────────────────────────────────────────────────
function increment(inputId) {
  const el = document.getElementById(inputId);
  if (el) el.value = Math.min(parseInt(el.value || 1) + 1, 99);
}

function decrement(inputId) {
  const el = document.getElementById(inputId);
  if (el) el.value = Math.max(parseInt(el.value || 1) - 1, 1);
}

// ── CONFIRM DIALOGS ──────────────────────────────────────────────
function confirmAction(msg, formId) {
  if (confirm(msg)) {
    document.getElementById(formId).submit();
  }
}

// ── AUTO-DISMISS ALERTS ──────────────────────────────────────────
document.addEventListener('DOMContentLoaded', function () {
  const alerts = document.querySelectorAll('.alert[data-dismiss="auto"]');
  alerts.forEach(a => setTimeout(() => a.remove(), 4000));
});

// ── PRINT BILL ───────────────────────────────────────────────────
function printBill() {
  window.print();
}

// ── PDF BILL DOWNLOAD (client-side via print dialog) ─────────────
function downloadBill() {
  const btn = document.getElementById('billActions');
  if (btn) btn.style.display = 'none';
  window.print();
  if (btn) btn.style.display = '';
}

// ── CART QUANTITY LIVE UPDATE ────────────────────────────────────
document.addEventListener('DOMContentLoaded', function () {
  document.querySelectorAll('.qty-update').forEach(function (input) {
    input.addEventListener('change', function () {
      this.closest('form').submit();
    });
  });
});

// ── GPS MAP ANIMATION ────────────────────────────────────────────
function initDeliveryMap(lat, lng) {
  const map = document.getElementById('deliveryMap');
  if (!map) return;
  // In production, integrate Google Maps or Leaflet here
  // For now, display coordinates
  map.innerHTML = '<div class="map-placeholder"><span>🗺️</span><p>Driver at: ' +
    lat + ', ' + lng + '</p><p style="font-size:0.75rem;opacity:0.7">Live tracking available in production</p></div>';
}
