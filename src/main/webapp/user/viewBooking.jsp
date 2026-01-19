<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>



<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>My Bookings</title>

    <!-- Google Font + Icons -->
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>

    <style>
        :root {
           --bg: #f6f9fc; 
		  --card-bg: #ffffff;
		  --primary: #3b82f6; 
		  --muted: #8b97a8;
		  --success: #10b981;
		  --shadow: 0 6px 18px rgba(39, 57, 84, 0.06);
		  --radius: 12px;
		  --glass: rgba(255, 255, 255, 0.6);
        }

        * { box-sizing: border-box; }

        html, body {
          height: 100%;
		  margin: 0;
		  padding:0;
		  font-family: Inter, system-ui, -apple-system, "Segoe UI", Roboto, Helvetica,
		    Arial, sans-serif;
		  background: var(--bg);
		  color: #1f2937;
            
        }

     
     /* SIDEBAR */
        
       
    .sidebar {
        position: fixed;
        top: 0;
        left: 0;
        width: 260px;
        height: 100vh;
        background: #ffffff;
        border-right: 1px solid #e5e7eb;
        display: flex;
        flex-direction: column;
        justify-content: space-between;
        padding: 20px 0;
    }
    
     #logo{
       margin-top:-20px;
       display:flex;
	   justify-content:center;
	   align-items:center;
	   gap:12px;
	   border-bottom: 1px solid #e5e7eb;
    
    }
    
    #logo i{
        padding: 10px ;
        color:white;
        background: linear-gradient(to right, #6366f1, #7c3aed);
        font-size:12px;
        border-radius:5px;
        margin-top:10px;
       
    }
    
    .sidebar h2 {
       color: #1559c5;
        font-size: 22px;
        font-weight: 600;
    }
    
    #small-text{
       font-size:10px;
       color:#6b7280;
       margin-top:-20px;
    
    }
    

    .sidebar a {
        display: flex;
        align-items: center;
        gap: 15px;
        padding: 12px 20px;
        color: #6b7280;
        text-decoration: none;
        margin-bottom: 8px;
        font-size: 15px;
        border-radius: 10px;
        transition: all 0.2s;
    }

    .sidebar a:hover {
        background: #f0f6ff;
        color: #1559c5;
        font-weight: 600;
    }

    .sidebar i {
        min-width: 20px;
        text-align: center;
    }

   .top-links{
       margin:20px 0px;
    }
   
    .sidebar .bottom-links {
        margin:400px 0px;
    }
       


        /**********************************
                 BEAUTIFUL CARD LAYOUT
        **********************************/
        .main {
            margin-left: 260px;
            padding: 30px 40px;
           
        }

        .title-row {
		  display: flex;
		  justify-content: space-between;
		  flex-direction:column;
	      margin-bottom: 30px;
		}
		.title-row h1 {
		  margin: 0;
		  font-size: 26px;
		  letter-spacing: -0.2px;
		}
		.subtitle {
		  color: var(--muted);
		  font-size: 13px;
		  margin-top: 6px;
		}
		

        .bookings {
            display:grid;
            grid-template-columns: repeat(3, 1fr);
             gap: 30px;               
             margin-top: 20px;
        }

        .booking-card {
          width: 380px;
		  background: var(--card-bg);
		  border-radius: var(--radius);
		  padding: 18px;
		  box-shadow: var(--shadow);
		  border: 1px solid rgba(15, 23, 42, 0.03);
		}
		
		.card-top {
		  display: flex;
		  justify-content: space-between;
		  align-items: center;
		  gap: 8px;
		}
		.slot-left {
		  display: flex;
		  gap: 12px;
		  align-items: center;
		}
		.slot-icon {
		  width: 48px;
		  height: 48px;
		  border-radius: 12px;
		  background: linear-gradient(
		    180deg,
		    rgba(59, 130, 246, 0.08),
		    rgba(59, 130, 246, 0.02)
		  );
		  display: flex;
		  align-items: center;
		  justify-content: center;
		  color: var(--primary);
		  font-size: 18px;
		  flex-shrink: 0;
		}
		.slot-meta strong {
		  font-size: 15px;
		  display: block;
		}
		.slot-meta small {
		  color: var(--muted);
		  font-size: 12px;
		}
		
		.status-pill {
		  background: var(--primary);
		  color: white;
		  font-size: 12px;
		  padding: 6px 10px;
		  border-radius: 10px;
		  display: inline-flex;
		  gap: 8px;
		  align-items: center;
		  font-weight: 600;
		}
		.status-pill i {
		  font-size: 13px;
		}
        

        .status-pill.cancelled {
            background: #dc2626;
        }
        
        
        .times {
		  display: flex;
		  justify-content: space-between;
		  gap: 12px;
		  margin-top: 14px;
		}
		.time-block small {
		  color: var(--muted);
		  display: block;
		  font-size: 12px;
		}
		.time-block strong {
		  display: block;
		  margin-top: 6px;
		  font-size: 14px;
		}
		
		.vehicle {
		  margin-top: 12px;
		  color: var(--muted);
		  font-size: 13px;
		}
				
				
		.actions-row {
		  display: flex;
		  justify-content: space-between;
		  margin-top: 16px;
		  gap: 10px;
		}
		
		.cancel-btn {
		  margin-top: 16px;
		  flex: 1;
		  padding: 10px 12px;
		  border-radius: 10px;
		  background: #fee2e2;
		  border: 1px solid #fecaca;
		  color: #dc2626;
		  font-weight: 600;
		  cursor: pointer;
		  font-size: 14px;
		  display: flex;
		  justify-content: center;
		  align-items: center;
		  gap: 6px;
		  transition: 0.2s;
		}
		
		.cancel-btn:hover {
		  background: #fecaca;
		}		        
        

       .details-btn {
		  margin-top: 16px;
		  width: 100%;
		  padding: 10px 12px;
		  border-radius: 10px;
		  border: 1px solid rgba(59, 130, 246, 0.12);
		  background: #eff6ff;
		  color: var(--primary);
		  font-weight: 600;
		  cursor: pointer;
		  display: flex;
		  align-items: center;
		  justify-content: center;
		  gap: 10px;
		  font-size: 14px;
		}

        
	/* Modal overlay & box */
	.modal-overlay {
	  position: fixed;
	  inset: 0;
	  display: none;
	  background: rgba(8, 7, 10, 0.6);
	  align-items: center;
	  justify-content: center;
	  z-index: 60;
	  padding: 30px;
	}
	.modal {
	  width: 320px;
	  background: var(--card-bg);
	  border-radius: 10px;
	  padding: 18px;
	  box-shadow: 0 20px 60px rgba(8, 15, 40, 0.35);
	  position: relative;
	  border: 1px solid rgba(15, 23, 42, 0.06);
	  animation: pop 0.16s ease;
	}
	@keyframes pop {
	  from {
	    transform: translateY(8px) scale(0.98);
	    opacity: 0;
	  }
	  to {
	    transform: translateY(0) scale(1);
	    opacity: 1;
	  }
	}
	.modal .close {
	  position: absolute;
	  right: 10px;
	  top: 8px;
	  background: transparent;
	  border: none;
	  font-size: 18px;
	  color: var(--muted);
	  cursor: pointer;
	  padding: 6px;
	  border-radius: 8px;
	}
	.modal h3 {
	  margin: 6px 0 10px 0;
	  font-size: 15px;
	}
	
	.modal-grid {
	  display: grid;
	  grid-template-columns: 1fr 1fr;
	  gap: 10px;
	  margin-top: 6px;
	}
	.md-cell {
	  background: #f8fafc;
	  padding: 10px;
	  border-radius: 8px;
	  border: 1px solid rgba(15, 23, 42, 0.02);
	  min-height: 44px;
	}
	.md-label {
	  font-size: 12px;
	  color: var(--muted);
	  display: block;
	}
	.md-value {
	  font-weight: 600;
	  margin-top: 6px;
	  font-size: 13px;
	}
	
	.booking-id {
	  margin-top: 12px;
	  background: #f8fafc;
	  padding: 10px;
	  border-radius: 8px;
	  border: 1px solid rgba(15, 23, 42, 0.02);
	  font-size: 12px;
	  color: #334155;
	  word-break: break-all;
	  margin-bottom:10px;
	}
	
	.status-pill.expired {
    background: #6b7280; /* gray */
}
	
	.status-pill.active {
    background:#4CAF50;
    }

	
	
	/* small responsive tweak */
	@media (max-width: 760px) {
	  .app {
	    grid-template-columns: 1fr;
	  }
	  .sidebar {
	    display: none;
	  }
	  .bookings {
	    justify-content: center;
	  }
	}
	
	
	.filter-row {
  display: flex;
  gap: 10px;
  margin-bottom: 20px;
  flex-wrap: wrap;
}

.filter-btn {
  padding: 8px 14px;
  border-radius: 999px;
  border: 1px solid #e5e7eb;
  background: white;
  font-size: 13px;
  cursor: pointer;
  color: #374151;
  transition: 0.2s;
}

.filter-btn:hover {
  background: #f1f5f9;
}

.filter-btn.active {
  background: #3b82f6;
  color: white;
  border-color: #3b82f6;
}

#cancel-msg {
    font-style: italic;
    background: #fef2f2;
    padding: 4px 8px;
    border-radius: 6px;
    display: inline-block;
    margin-top: 4px;
}


#md-refund {
    margin-top: 6px;
    padding: 6px 10px;
    background: #ecfdf5; 
    border-left: 4px solid #10b981; 
    border-radius: 6px;
    gap: 6px;
    font-size: 13px;
    color: #065f46; 
    display: flex;
    justify-content: space-between; 
}

#md-refund .md-label {
    font-weight: 500; 
}

#md-refund .md-value {
    font-weight: 600; 
}


	
    </style>
</head>

<body>

<div class="sidebar">
  <div>
  
    <div id="logo">
      <i class="fa-solid fa-car"></i>
      <div>
        <h2>ParkEase</h2>
        <p id="small-text">Pre-Booking System</p>
      </div>
    </div>

    <div class="top-links">
      <a href="${pageContext.request.contextPath}/user/userDashboard.jsp"><i class="fa-solid fa-gauge"></i> Dashboard</a>
      <a href="${pageContext.request.contextPath}/user/booking-page"><i class="fa-solid fa-ticket"></i> Book Slot</a>
      <a href="${pageContext.request.contextPath}/user/view-bookings"><i class="fa-solid fa-list-check"></i> My Bookings</a>
    </div>

    <div class="bottom-links">
      <a href="${pageContext.request.contextPath}/profile/profile.jsp"><i class="fa-solid fa-user"></i> Profile</a>
      <a href="${pageContext.request.contextPath}/logout"><i class="fa-solid fa-right-from-bracket"></i> Logout</a>
    </div>
    
  </div>
</div>

    <!-- MAIN CONTENT -->
 <main class="main">
 
   <div class="title-row">
       <h1>My Bookings</h1>
       <div class="subtitle">View and manage your reservations</div>
   </div>
   
   
   <!-- Messages for cancellation -->
<c:choose>
  <c:when test="${param.cancel == 'penalty'}">
    <div style="color:#b91c1c; margin-bottom:10px;">
       You have canceled late. A penalty has been applied.
    </div>
  </c:when>
  <c:when test="${param.cancel == 'success'}">
    <div style="color:#10b981; margin-bottom:10px;">
       Booking canceled successfully.
    </div>
  </c:when>
  <c:when test="${param.cancel == 'tooLate'}">
    <div style="color:#facc15; margin-bottom:10px;">
       Too late to cancel this booking.
    </div>
  </c:when>
  <c:when test="${param.cancel == 'failed'}">
    <div style="color:#ef4444; margin-bottom:10px;">
       Unable to cancel this booking.
    </div>
  </c:when>
</c:choose>
   
   <div class="filter-row">
		  <button class="filter-btn active" data-filter="ALL">All</button>
		  <button class="filter-btn" data-filter="BOOKED">Booked</button>
		 <button class="filter-btn" data-filter="ACTIVE">Active</button>
		  <button class="filter-btn" data-filter="EXPIRED">Expired</button>
		  <button class="filter-btn" data-filter="CANCELLED">Cancelled</button>
		  <button class="filter-btn" data-filter="COMPLETED">Completed</button>
   </div>
   

   <section class="bookings">
        
     <c:if test="${empty bookings}">
     <h3>No bookings found.</h3>
     </c:if>

<c:forEach var="b" items="${bookings}">
     
         <!-- Card for each booking -->
<div class="booking-card"
     data-slot="${b.slotNumber}"
     data-status="${b.status}"
     data-date="${b.startDate}"
     data-vehicle="${b.vehicleNumber}"
     data-start="${b.startTimeFormatted}"
     data-end="${b.endTimeFormatted}"
     data-id="${b.bookingId}"
     data-estimated="₹ ${b.estimatedAmount}"
  data-final="${b.finalAmount != null ? b.finalAmount : '--'}"
  data-penalty-applicable="${b.penaltyApplicable ? 'true' : 'false'}"
   
     data-penalty-amount="₹${b.penaltyAmount}">



   <div class="card-top">
                
      <div  class="slot-left">
                    
        <div class="slot-icon">
        <i class="fa-solid fa-location-dot"></i>
        </div>

         <div class="slot-meta">
             <strong>Slot ${b.slotNumber}</strong>
              <small>${b.startDate}</small>
          </div>
                        
        </div>
        
      <div class="status-pill
     ${b.status == 'ACTIVE' ? 'active' : ''} 
     ${b.status == 'CANCELLED' ? 'cancelled' : ''}
     ${b.status == 'EXPIRED' ? 'expired' : ''}">
      
       <c:choose>
  <c:when test="${b.status == 'EXPIRED'}">
    EXPIRED (No-Show)
  </c:when>
  <c:otherwise>
    ${b.status}
  </c:otherwise>
</c:choose>
       
       </div>
       
    </div>
                
    <div class="times">

       <div class="time-block">
         <small>Start</small>
         <strong>${b.startTimeFormatted}</strong>
        </div>
	
	     <div class="time-block" style="text-align: right">
            <small>End</small>
           <strong>${b.endTimeFormatted}</strong>
	      </div>
	      
    </div>
	             
    <div class="vehicle">
    Vehicle: <strong>${b.vehicleNumber}</strong>
</div>

<c:if test="${b.status == 'EXPIRED'}">
  <div style="
       margin-top: 8px;
       padding: 8px 10px;
       background: #f3f4f6;
       border-radius: 8px;
       font-size: 13px;
       color: #374151;">
    <i class="fa-solid fa-triangle-exclamation"></i>
    No-show penalty applied:
    <span data-final>
  <c:choose>
    <c:when test="${not empty b.finalAmount}">
        ₹ ${b.finalAmount}
    </c:when>
    <c:otherwise>
        --
    </c:otherwise>
  </c:choose>
</span>
    
  </div>
</c:if>
    
               
 <div class="actions-row">
    
    <!-- Details button -->
    <button class="details-btn">Details
        <i class="fa-solid fa-chevron-down" style="font-size: 12px"></i>
    </button>     

    <!-- Cancel button (only for BOOKED bookings) -->
    <c:if test="${b.status == 'BOOKED'}">
        <form action="${pageContext.request.contextPath}/user/booking-action"
              method="post"
              onsubmit="return confirm('Cancel this booking?');">

            <input type="hidden" name="action" value="cancel">
            <input type="hidden" name="bookingId" value="${b.bookingId}">

            <button type="submit" class="cancel-btn btn-danger btn-sm">
                Cancel
            </button>
        </form>

      
    </c:if>
    
    
  

    

</div>
 
      </div>
      
</c:forEach>
</section>
</main>


<!-- Modal -->
<div class="modal-overlay" id="modalOverlay">

   <div class="modal" role="document" aria-labelledby="mdTitle">

        <button class="close" id="modalClose" aria-label="Close">
          <i class="fa-solid fa-xmark"></i>
        </button>
   
         <h3 id="mdTitle">Booking Details</h3>
       
        
         <div class="modal-grid">
         
          <div class="md-cell">
            <span class="md-label">Slot:</span>
            <div class="md-value" id="md-slot"></div>
          </div>
          
          <div class="md-cell">
            <span class="md-label">Status</span>
            <div class="md-value" id="md-status"></div>
          </div>

          <div class="md-cell">
            <span class="md-label">Date</span>
            <div class="md-value" id="md-date"></div>
          </div>
          
          <div class="md-cell">
            <span class="md-label">Vehicle</span>
            <div class="md-value" id="md-vehicle"></div>
          </div>

          <div class="md-cell">
            <span class="md-label">Start Time</span>
            <div class="md-value" id="md-start"></div>
          </div>
          
          <div class="md-cell">
            <span class="md-label">End Time</span>
            <div class="md-value" id="md-end"></div>
          </div>
          
          <div class="md-cell">
		  <span class="md-label">Estimated Fee</span>
		  <div class="md-value" id="md-estimated"></div>
		</div>
		
		<div class="md-cell">
		  <span class="md-label">Final Fee</span>
		  <div class="md-value" id="md-final"></div>
		</div>
		
		<div class="md-cell" id="md-refund"
     style="display:none; background:#ecfdf5; border-left:4px solid #10b981;">
  <span class="md-label">Refund</span>
  <div class="md-value" id="md-refund-amount"></div>
</div>
		
          
        </div>

        <div class="md-cell" style="margin-top: 16px">
          <span class="md-label">booking-id</span>
          <div class="booking-id" id="md-id"></div>
        </div>
     
     
     <div class="md-cell" id="md-penalty"
     style="background:#fff1f2; color:#b91c1c; font-size:13px;
            display:none; margin-top:10px; border-left:4px solid #ef4444; padding:8px;">
    ⚠ Late cancellation fee: <span id="md-penalty-amount"></span>
</div>
     
        
        
        
     </div>
     
  </div>



<script>

const overlay = document.getElementById("modalOverlay");
const closeBtn = document.getElementById("modalClose");

document.querySelectorAll(".booking-card").forEach(card => {
  card.querySelector(".details-btn").addEventListener("click", () => {
	  
	  console.log(card.dataset.penaltyApplicable);


    document.getElementById("md-slot").textContent = card.dataset.slot;
    document.getElementById("md-status").textContent = card.dataset.status;
    document.getElementById("md-date").textContent = card.dataset.date;
    document.getElementById("md-vehicle").textContent = card.dataset.vehicle;
    document.getElementById("md-start").textContent = card.dataset.start;
    document.getElementById("md-end").textContent = card.dataset.end;
    document.getElementById("md-id").textContent = card.dataset.id;
    document.getElementById("md-estimated").textContent = card.dataset.estimated;
    document.getElementById("md-final").textContent =
    	  card.dataset.final !== "--" ? "₹ " + card.dataset.final : "--";

    
    const estimated = parseFloat(card.dataset.estimated.replace("₹",""));
    const finalAmtText = card.dataset.final.replace("₹","").trim();

    const refundDiv = document.getElementById("md-refund");
    const refundAmt = document.getElementById("md-refund-amount");

    if (finalAmtText !== "--") {
      const finalAmt = parseFloat(finalAmtText);
      const refund = estimated - finalAmt;

      if (
        refund > 0 &&
        (card.dataset.status === "CANCELLED" || card.dataset.status === "EXPIRED")
      ) {
        refundDiv.style.display = "block";
        refundAmt.textContent = "₹ " + refund;
      } else {
        refundDiv.style.display = "none";
      }
    } else {
      refundDiv.style.display = "none";
    }


    const penaltyDiv = document.getElementById("md-penalty");
    const penaltyAmount = document.getElementById("md-penalty-amount");

    if (card.dataset.penaltyApplicable === "true") {
      penaltyDiv.style.display = "block";
      penaltyAmount.textContent = card.dataset.penaltyAmount;
    } else {
      penaltyDiv.style.display = "none";
    }

    overlay.style.display = "flex";
    overlay.setAttribute("aria-hidden", "false");
    closeBtn.focus();
  });
});

function closeModal() {
  overlay.style.display = "none";
  overlay.setAttribute("aria-hidden", "true");
}

closeBtn.addEventListener("click", closeModal);

overlay.addEventListener("click", (e) => {
  if (e.target === overlay) closeModal();
});

// ESC key
window.addEventListener("keydown", (e) => {
  if (e.key === "Escape" && overlay.style.display === "flex") {
    closeModal();
  }
});

    
    
 // ESC to close
    window.addEventListener("keydown", (e) => {
      if (e.key === "Escape" && overlay.style.display === "flex") {
        closeModal();
      }
    });

   
    const filterButtons = document.querySelectorAll(".filter-btn");
    const bookingCards = document.querySelectorAll(".booking-card");

    filterButtons.forEach(btn => {
      btn.addEventListener("click", () => {

        // Active state
        filterButtons.forEach(b => b.classList.remove("active"));
        btn.classList.add("active");

        const filter = btn.dataset.filter;

        bookingCards.forEach(card => {
          const status = card.dataset.status;

          if (filter === "ALL" || status === filter) {
            card.style.display = "block";
          } else {
            card.style.display = "none";
          }
        });
      });
    });
    
</script>

</body>
</html>
