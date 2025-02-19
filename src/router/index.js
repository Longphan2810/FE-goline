import { createRouter, createWebHistory } from 'vue-router'
import Apartment from '../components/Apartment.vue'
import RoomComponent from '../components/RoomComponent.vue'
import NotFound from '../components/notFound.vue'

const routes = [
  { path: '/', component: Apartment },
  { path: '/rooms', component: RoomComponent, props:true },
  { path: "/:pathMatch(.*)*", name: "NotFound", component: NotFound },
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router
