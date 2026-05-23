<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Bill – FreshCart</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
  <!-- jsPDF for PDF generation -->
  <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf-autotable/3.8.2/jspdf.plugin.autotable.min.js"></script>
  <style>
    @media print {
      .no-print { display: none !important; }
      body { background: white; }
      .bill-container { box-shadow: none; }
    }
    .bill-action-bar {
      display: flex; gap: 0.75rem; padding: 1rem 0;
      flex-wrap: wrap;
    }
    .pdf-btn {
      background: linear-gradient(135deg, #b71c1c, #e53935);
      color: white; border: none;
      padding: 0.75rem 1.5rem; border-radius: 10px;
      font-family: 'Nunito', sans-serif; font-size: 0.95rem; font-weight: 800;
      cursor: pointer; display: flex; align-items: center; gap: 0.5rem;
      transition: all 0.25s; box-shadow: 0 4px 15px rgba(229,57,53,0.35);
    }
    .pdf-btn:hover { transform: translateY(-2px); box-shadow: 0 8px 24px rgba(229,57,53,0.45); }
    .pdf-btn:active { transform: scale(0.97); }
  </style>
</head>
<body>
<div class="no-print">
  <jsp:include page="navbar.jsp"/>
</div>

<div class="container">

  <%-- Action buttons --%>
  <div id="billActions" class="bill-action-bar no-print">
    <button class="pdf-btn" onclick="downloadPDF()">
      📄 Download PDF Bill
    </button>
    <button onclick="window.print()" class="btn btn-secondary">
      🖨️ Print
    </button>
  </div>

  <%-- ── BILL RECEIPT ── --%>
  <div class="bill-container" id="billReceipt">
    <div class="bill-header">
      <div style="font-size:2.2rem; margin-bottom:0.4rem;">🛒</div>
      <h2>FreshCart</h2>
      <p>Online Grocery Store</p>
      <p style="margin-top:0.5rem; font-size:0.82rem; opacity:0.75;">
        Order ID: <strong>${order.orderId}</strong> &nbsp;|&nbsp; Date: ${order.orderDate}
      </p>
    </div>

    <div class="bill-body">
      <%-- Customer & status info --%>
      <div style="display:flex; justify-content:space-between; margin-bottom:1.25rem; font-size:0.9rem; flex-wrap:wrap; gap:0.75rem;">
        <div>
          <div style="font-weight:700; color:var(--text-light); font-size:0.74rem; text-transform:uppercase; letter-spacing:0.5px; margin-bottom:0.3rem;">Billed To</div>
          <div style="font-weight:800; font-size:1rem;">${sessionScope.loggedUser.username}</div>
          <div style="color:var(--text-mid);">${sessionScope.loggedUser.email}</div>
        </div>
        <div style="text-align:right;">
          <div style="font-weight:700; color:var(--text-light); font-size:0.74rem; text-transform:uppercase; letter-spacing:0.5px; margin-bottom:0.3rem;">Status</div>
          <span class="status-badge status-pending">Pending Fulfillment</span>
        </div>
      </div>

      <%-- Items table --%>
      <table class="bill-table" id="itemsTable">
        <thead>
          <tr>
            <th>#</th>
            <th>Item</th>
            <th style="text-align:center;">Qty</th>
            <th style="text-align:right;">Unit Price</th>
            <th style="text-align:right;">Discount</th>
            <th style="text-align:right;">Subtotal</th>
          </tr>
        </thead>
        <tbody>
          <c:set var="grandTotal"     value="0"/>
          <c:set var="totalDiscount"  value="0"/>
          <c:set var="counter"        value="1"/>
          <c:forEach var="item" items="${orderItems}">
            <c:set var="discountAmt" value="${item.price * item.discountPercent / 100 * item.quantity}"/>
            <c:set var="subtotal"    value="${item.subtotal}"/>
            <c:set var="totalDiscount" value="${totalDiscount + discountAmt}"/>
            <tr>
              <td style="color:var(--text-light);">${counter}</td>
              <td>
                ${item.productName}
                <c:if test="${item.discountPercent > 0}">
                  <span style="font-size:0.72rem; color:var(--red); font-weight:700;"> ⚠️ Near-Expiry</span>
                </c:if>
              </td>
              <td style="text-align:center;">${item.quantity}</td>
              <td style="text-align:right;">LKR <fmt:formatNumber value="${item.price}" pattern="#,##0.00"/></td>
              <td style="text-align:right; color:var(--red);">
                <c:choose>
                  <c:when test="${item.discountPercent > 0}">
                    <fmt:formatNumber value="${item.discountPercent}" pattern="#,##0"/>%
                    (-LKR <fmt:formatNumber value="${discountAmt}" pattern="#,##0.00"/>)
                  </c:when>
                  <c:otherwise>—</c:otherwise>
                </c:choose>
              </td>
              <td style="text-align:right; font-weight:800;">LKR <fmt:formatNumber value="${subtotal}" pattern="#,##0.00"/></td>
            </tr>
            <c:set var="counter" value="${counter + 1}"/>
          </c:forEach>
        </tbody>
      </table>

      <%-- Totals --%>
      <div class="bill-total-section">
        <div class="bill-row">
          <span style="color:var(--text-mid);">Subtotal (before discounts)</span>
          <span>LKR <fmt:formatNumber value="${total + totalDiscount}" pattern="#,##0.00"/></span>
        </div>
        <c:if test="${totalDiscount > 0}">
          <div class="bill-row" style="color:var(--red);">
            <span>🏷️ Near-Expiry Discount</span>
            <span>-LKR <fmt:formatNumber value="${totalDiscount}" pattern="#,##0.00"/></span>
          </div>
        </c:if>
        <div class="bill-row" style="color:var(--text-mid);">
          <span>Delivery Fee</span>
          <span>To be determined</span>
        </div>
        <div style="border-top:2px solid var(--border); margin-top:0.5rem; padding-top:0.5rem;">
          <div class="bill-row total">
            <span>Net Total</span>
            <span>LKR <fmt:formatNumber value="${total}" pattern="#,##0.00"/></span>
          </div>
        </div>
      </div>

      <%-- Thank you message --%>
      <div style="margin-top:1.5rem; padding:1rem; background:var(--green-pale); border-radius:var(--radius-sm); text-align:center; font-size:0.85rem;">
        <strong>Thank you for shopping at FreshCart! 🛒</strong><br>
        <span style="color:var(--text-light);">Please choose your fulfillment option below.</span>
      </div>
    </div>
  </div>

  <%-- ── FULFILLMENT SELECTION ── --%>
  <div class="no-print" style="max-width:700px; margin:1.5rem auto;">
    <div class="card">
      <div style="font-size:1.1rem; font-weight:800; margin-bottom:1.25rem; text-align:center;">
        How would you like to receive your order?
      </div>
      <div style="display:grid; grid-template-columns:1fr 1fr; gap:1rem;">

        <%-- Pickup --%>
        <form method="post" action="${pageContext.request.contextPath}/shop/fulfillment">
          <input type="hidden" name="orderId" value="${order.orderId}">
          <input type="hidden" name="type" value="PICKUP">
          <button type="submit" class="btn btn-secondary btn-block"
                  style="height:110px; flex-direction:column; font-size:1rem; border:2px solid var(--border);">
            <span style="font-size:2.2rem;">🏪</span>
            <span style="font-weight:800;">Pickup at Store</span>
            <span style="font-size:0.75rem; color:var(--text-light);">Free – Ready in 2 hours</span>
          </button>
        </form>

        <%-- Delivery --%>
        <button type="button" class="btn btn-primary btn-block"
                style="height:110px; flex-direction:column; font-size:1rem;"
                onclick="document.getElementById('deliveryForm').style.display='block'; this.style.display='none';">
          <span style="font-size:2.2rem;">🚚</span>
          <span style="font-weight:800;">Home Delivery</span>
          <span style="font-size:0.75rem; opacity:0.85;">LKR 150 – 1-3 days</span>
        </button>
      </div>

      <%-- Delivery address form --%>
      <div id="deliveryForm" style="display:none; margin-top:1.5rem; border-top:2px solid var(--border); padding-top:1.5rem;">
        <div style="font-weight:800; font-size:1rem; margin-bottom:1rem;">🚚 Delivery Details</div>
        <form method="post" action="${pageContext.request.contextPath}/shop/fulfillment">
          <input type="hidden" name="orderId" value="${order.orderId}">
          <input type="hidden" name="type" value="DELIVERY">
          <div style="display:grid; grid-template-columns:1fr 1fr; gap:1rem;">
            <div class="form-group" style="grid-column:1/-1;">
              <label class="form-label">Delivery Address</label>
              <input type="text" name="address" class="form-control" placeholder="No. 45, Temple Road, Nugegoda" required>
            </div>
            <div class="form-group">
              <label class="form-label">Postal Code</label>
              <input type="text" name="postalCode" class="form-control" placeholder="10250" required>
            </div>
            <div class="form-group">
              <label class="form-label">District</label>
              <select name="district" class="form-control" required>
                <option value="">Select District</option>
                <option>Colombo</option><option>Gampaha</option><option>Kalutara</option>
                <option>Kandy</option><option>Matale</option><option>Nuwara Eliya</option>
                <option>Galle</option><option>Matara</option><option>Hambantota</option>
                <option>Jaffna</option><option>Kilinochchi</option><option>Mannar</option>
                <option>Mullaitivu</option><option>Vavuniya</option><option>Puttalam</option>
                <option>Kurunegala</option><option>Anuradhapura</option><option>Polonnaruwa</option>
                <option>Badulla</option><option>Monaragala</option><option>Ratnapura</option>
                <option>Kegalle</option><option>Trincomalee</option><option>Batticaloa</option>
                <option>Ampara</option>
              </select>
            </div>
            <div class="form-group">
              <label class="form-label">Province</label>
              <select name="province" class="form-control" required>
                <option value="">Select Province</option>
                <option>Western</option><option>Central</option><option>Southern</option>
                <option>Northern</option><option>Eastern</option><option>North Western</option>
                <option>North Central</option><option>Uva</option><option>Sabaragamuwa</option>
              </select>
            </div>
            <div class="form-group" style="grid-column:1/-1;">
              <label class="form-label">Mobile Number</label>
              <input type="tel" name="mobile" class="form-control" placeholder="07X XXXXXXX" required>
            </div>
          </div>
          <button type="submit" class="btn btn-primary btn-block btn-lg">Confirm Delivery Order →</button>
        </form>
      </div>
    </div>
  </div>

</div><%-- end container --%>

<script src="${pageContext.request.contextPath}/static/js/main.js"></script>
<script>
// ── PDF DOWNLOAD using jsPDF + autoTable ──────────────────────────────────
function downloadPDF() {
  const { jsPDF } = window.jspdf;
  const doc = new jsPDF({ orientation: 'portrait', unit: 'mm', format: 'a4' });

  const pageW = doc.internal.pageSize.getWidth();
  const margin = 15;

  // ── Header background
  doc.setFillColor(21, 92, 42);
  doc.roundedRect(0, 0, pageW, 45, 0, 0, 'F');

  // ── Logo text
  doc.setTextColor(255, 255, 255);
  doc.setFontSize(26);
  doc.setFont('helvetica', 'bold');
  doc.text('Fresh', margin, 22);
  doc.setTextColor(255, 213, 79);
  doc.text('Cart', margin + 33, 22);

  doc.setTextColor(255, 255, 255);
  doc.setFontSize(9);
  doc.setFont('helvetica', 'normal');
  doc.text('Online Grocery Store', margin, 30);

  // ── Order info right side
  doc.setFontSize(9);
  doc.text('Order ID: ${order.orderId}', pageW - margin, 18, { align: 'right' });
  doc.text('Date: ${order.orderDate}', pageW - margin, 25, { align: 'right' });

  // ── Bill To section
  doc.setTextColor(30, 30, 30);
  doc.setFontSize(9);
  doc.setFont('helvetica', 'bold');
  doc.text('BILLED TO', margin, 58);
  doc.setFont('helvetica', 'normal');
  doc.setFontSize(11);
  doc.text('${sessionScope.loggedUser.username}', margin, 65);
  doc.setFontSize(9);
  doc.setTextColor(100, 100, 100);
  doc.text('${sessionScope.loggedUser.email}', margin, 71);

  // Status badge
  doc.setFillColor(230, 247, 236);
  doc.roundedRect(pageW - margin - 40, 54, 40, 10, 2, 2, 'F');
  doc.setTextColor(21, 92, 42);
  doc.setFontSize(8);
  doc.setFont('helvetica', 'bold');
  doc.text('PENDING FULFILLMENT', pageW - margin - 20, 60.5, { align: 'center' });

  // ── Items table
  const tableRows = [];
  <c:set var="rowNum" value="1"/>
  <c:forEach var="item" items="${orderItems}">
  <c:set var="disc" value="${item.price * item.discountPercent / 100 * item.quantity}"/>
  tableRows.push([
    '${rowNum}',
    '${item.productName}',
    '${item.quantity}',
    'LKR ${String.format("%.2f", item.price)}',
    '${item.discountPercent > 0 ? String.format("%.0f", item.discountPercent).concat("%") : "-"}',
    'LKR ${String.format("%.2f", item.subtotal)}'
  ]);
  <c:set var="rowNum" value="${rowNum + 1}"/>
  </c:forEach>

  doc.autoTable({
    head: [['#', 'Item', 'Qty', 'Unit Price', 'Discount', 'Subtotal']],
    body: tableRows,
    startY: 80,
    margin: { left: margin, right: margin },
    styles: { fontSize: 9, cellPadding: 3, font: 'helvetica' },
    headStyles: {
      fillColor: [21, 92, 42], textColor: 255,
      fontStyle: 'bold', fontSize: 8
    },
    alternateRowStyles: { fillColor: [245, 255, 248] },
    columnStyles: {
      0: { cellWidth: 8 },
      2: { halign: 'center' },
      3: { halign: 'right' },
      4: { halign: 'right', textColor: [183, 28, 28] },
      5: { halign: 'right', fontStyle: 'bold' }
    }
  });

  // ── Totals section
  let y = doc.lastAutoTable.finalY + 8;

  doc.setDrawColor(220, 220, 220);
  doc.line(margin, y, pageW - margin, y);
  y += 7;

  const totalsX = pageW - margin - 70;
  doc.setTextColor(100, 100, 100);
  doc.setFontSize(9);
  doc.setFont('helvetica', 'normal');

  doc.text('Subtotal (before discounts):', totalsX, y);
  doc.text('LKR ${String.format("%.2f", total + totalDiscount)}', pageW - margin, y, { align: 'right' });
  y += 6;

  <c:if test="${totalDiscount > 0}">
  doc.setTextColor(183, 28, 28);
  doc.text('Near-Expiry Discount:', totalsX, y);
  doc.text('-LKR ${String.format("%.2f", totalDiscount)}', pageW - margin, y, { align: 'right' });
  y += 6;
  </c:if>

  doc.setTextColor(100, 100, 100);
  doc.text('Delivery Fee:', totalsX, y);
  doc.text('To be determined', pageW - margin, y, { align: 'right' });
  y += 8;

  // Net total highlight box
  doc.setFillColor(230, 247, 236);
  doc.roundedRect(totalsX - 5, y - 5, pageW - margin - totalsX + 5, 12, 2, 2, 'F');
  doc.setTextColor(21, 92, 42);
  doc.setFontSize(11);
  doc.setFont('helvetica', 'bold');
  doc.text('NET TOTAL:', totalsX, y + 3);
  doc.text('LKR ${String.format("%.2f", total)}', pageW - margin, y + 3, { align: 'right' });
  y += 16;

  // ── Footer
  doc.setFillColor(21, 92, 42);
  doc.rect(0, 275, pageW, 22, 'F');
  doc.setTextColor(255, 255, 255);
  doc.setFontSize(8);
  doc.setFont('helvetica', 'normal');
  doc.text('Thank you for shopping at FreshCart!  |  freshcart.lk', pageW / 2, 284, { align: 'center' });
  doc.setTextColor(255, 213, 79);
  doc.text('Fresh Groceries Online', pageW / 2, 290, { align: 'center' });

  // Save
  doc.save('FreshCart_Bill_${order.orderId}.pdf');
}
</script>
</body>
</html>
