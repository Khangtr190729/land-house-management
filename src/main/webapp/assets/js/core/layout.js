(function () {
  const sidebar = document.getElementById("rhSidebar");
  const btnToggle = document.getElementById("rhToggleSidebar");
  const layout = document.querySelector(".rh-layout");
  const backdrop = document.getElementById("rhSidebarBackdrop");

  const logoutBtn = document.querySelector(".js-logout");
  const logoutModal = document.getElementById("rhLogoutModal");
  const closeLogoutModalBtn = document.getElementById("rhCloseLogoutModal");
  const cancelLogoutBtn = document.getElementById("rhCancelLogout");

  const isMobile = () => window.matchMedia("(max-width: 992px)").matches;

  function lockBody() {
    document.body.style.overflow = "hidden";
  }

  function unlockBody() {
    document.body.style.overflow = "";
  }

  function openMobileSidebar() {
    if (!sidebar) return;
    sidebar.classList.add("open");
    if (backdrop) backdrop.classList.add("show");
    lockBody();
  }

  function closeMobileSidebar() {
    if (!sidebar) return;
    sidebar.classList.remove("open");
    if (backdrop) backdrop.classList.remove("show");
    if (!logoutModal || !logoutModal.classList.contains("show")) {
      unlockBody();
    }
  }

  function toggleSidebar() {
    if (!sidebar || !layout) return;

    if (isMobile()) {
      if (sidebar.classList.contains("open")) {
        closeMobileSidebar();
      } else {
        openMobileSidebar();
      }
    } else {
      layout.classList.toggle("sidebar-hidden");
    }
  }

  if (btnToggle) {
    btnToggle.addEventListener("click", toggleSidebar);
  }

  if (backdrop) {
    backdrop.addEventListener("click", closeMobileSidebar);
  }

  if (sidebar) {
    sidebar.addEventListener("click", function (e) {
      const link = e.target.closest("a");
      if (link && isMobile()) {
        closeMobileSidebar();
      }
    });
  }

  window.addEventListener("resize", function () {
    if (!isMobile()) {
      closeMobileSidebar();
    }
  });

  const headerFilter = document.getElementById("rhOpenFilter");
  if (headerFilter) {
    headerFilter.addEventListener("click", function () {
      const btn = document.getElementById("btnOpenFilter");
      if (btn) btn.click();
    });
  }

  /* Spotlight effect */
  document.querySelectorAll(".rh-spotlight").forEach((el) => {
    el.addEventListener("mousemove", (e) => {
      const rect = el.getBoundingClientRect();
      const x = e.clientX - rect.left;
      const y = e.clientY - rect.top;
      el.style.setProperty("--mx", `${x}px`);
      el.style.setProperty("--my", `${y}px`);
    });
  });

  /* Ripple effect */
  document.querySelectorAll(".rh-ripple").forEach((el) => {
    el.addEventListener("click", function (e) {
      const rect = el.getBoundingClientRect();
      const wave = document.createElement("span");
      const size = Math.max(rect.width, rect.height);

      wave.className = "rh-ripple-wave";
      wave.style.width = `${size}px`;
      wave.style.height = `${size}px`;
      wave.style.left = `${e.clientX - rect.left - size / 2}px`;
      wave.style.top = `${e.clientY - rect.top - size / 2}px`;

      el.appendChild(wave);

      wave.addEventListener("animationend", () => {
        wave.remove();
      });
    });
  });

  /* Logout modal */
  function openLogoutModal() {
    if (!logoutModal) return;
    logoutModal.classList.add("show");
    logoutModal.setAttribute("aria-hidden", "false");
    lockBody();
  }

  function closeLogoutModal() {
    if (!logoutModal) return;
    logoutModal.classList.remove("show");
    logoutModal.setAttribute("aria-hidden", "true");

    if (!isMobile() || !sidebar?.classList.contains("open")) {
      unlockBody();
    }
  }

  if (logoutBtn) {
    logoutBtn.addEventListener("click", function (e) {
      e.preventDefault();
      openLogoutModal();
    });
  }

  if (closeLogoutModalBtn) {
    closeLogoutModalBtn.addEventListener("click", closeLogoutModal);
  }

  if (cancelLogoutBtn) {
    cancelLogoutBtn.addEventListener("click", closeLogoutModal);
  }

  if (logoutModal) {
    logoutModal.addEventListener("click", function (e) {
      if (e.target.matches("[data-close-modal='true']")) {
        closeLogoutModal();
      }
    });
  }

  document.addEventListener("keydown", function (e) {
    if (e.key === "Escape") {
      if (logoutModal && logoutModal.classList.contains("show")) {
        closeLogoutModal();
        return;
      }

      if (isMobile() && sidebar?.classList.contains("open")) {
        closeMobileSidebar();
      }
    }
  });
})();
