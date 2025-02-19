<template>
  <div class="container-fluid">
    <div class="row vh-100">
      <!-- Sidebar -->
      <div
        :class="['sidebar bg-dark text-white d-flex flex-column p-3', isSidebarHidden ? 'd-none d-md-flex col-md-3 col-lg-2' : 'col-12 col-md-3 col-lg-2']"
      >
        <Navbar />
      </div>

      <!-- Nội dung chính -->
      <div class="col d-flex flex-column">
        <!-- Nút Toggle Sidebar (Mobile) -->
        <button class="btn btn-dark d-md-none my-2 ms-2 align-self-start" @click="toggleSidebar">
          ☰ Menu
        </button>

        <div class="content flex-grow-1 p-3">
          <RouterView />
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import Navbar from "./components/Navbar/Navbar.vue";

export default {
  name: "App",
  components: {
    Navbar
  },
  data() {
    return {
      isSidebarHidden: window.innerWidth < 768 // Mặc định ẩn trên mobile
    };
  },
  methods: {
    toggleSidebar() {
      this.isSidebarHidden = !this.isSidebarHidden;
    },
    updateSidebar() {
      this.isSidebarHidden = window.innerWidth < 768;
    }
  },
  mounted() {
    window.addEventListener("resize", this.updateSidebar);
  },
  beforeUnmount() {
    window.removeEventListener("resize", this.updateSidebar);
  }
};
</script>

<style scoped>
/* Sidebar full chiều cao */
.sidebar {
  height: 100vh;
  transition: transform 0.3s ease-in-out;
}

/* Nội dung chính */
.content {
  background: rgb(246, 246, 247);
  overflow-y: auto;
}
</style>
