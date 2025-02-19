<template>
  <div class="container-fluid">
    <!-- loading -->
    <div v-if="loading" class="loading-overlay">
      <div class="spinner-border text-light"></div>
    </div>

    <button class="btn btn-primary my-1" @click="$router.go(-1)">Quay lại</button>
    <!-- {{ apartDetail }} -->
    <div class="modal-body">
      <div class="w-100 h-100 p-1 ">
        <div class=" row ms-auto ">

          <div class="col-3">
            <img
              :src="apartDetail.image ? apartDetail.image : 'http://res.cloudinary.com/djxfzinut/image/upload/v1739845358/hvgwzmzqv0sbdqnlb35w.png'"
              class="img-thumbnail border mx-auto" id="previewImage" alt="." style="height: 200px; width: 100%">
          </div>
          <div class="col-9 ">
            <div class="row">

              <div class="col-12 mb-2">
                <h4 for="inputAddress" class="form-label">Tên căn hộ :{{ apartDetail.name }}
                </h4>
              </div>
              <div class="col-12 mb-2">
                <h4 for="inputAddress" class="form-label">Địa chỉ : {{ apartDetail.address
                }}</h4>
              </div>
              <div class="col-md-12 mb-2">
                <h4 for="inputPassword4" class="form-label">Trạng thái : 
                  <span v-if="!apartDetail.isAvailable" class="text-danger">Tạm khoá</span>
                  <span v-if="apartDetail.isAvailable" class="text-primary">Đang có sẵn</span>
                
                </h4>
              </div>
              <div class="col-3">
                <button type="button" data-bs-toggle="modal" @click="changeModalCurrentRoom('add')"
                  data-bs-target="#exampleModal" class="me-2 btn btn-primary"> + Thêm phòng</button>
              </div>
            </div>
          </div>


          <!-- enđ off -->
          <div class="col-12 border-top mt-3 ">

            <div class="d-flex row container  my-2 ">
              <div class="col-md-4">
                <h5>Tìm theo tên phòng </h5>
                <div class="input-group mb-1 ">
                  <span class="input-group-text " id="basic-addon1">&#128269;
                  </span>
                  <input type="text" class="form-control input-search " v-model="nameRoom" placeholder="Search"
                    aria-label="Username" aria-describedby="basic-addon1">

                </div>
              </div>

              <div class="col-md-3">
                <h5>Trạng thái</h5>
                <select id="inputState" v-model="statusRoom" class="form-select" name="isSellingFilter">
                  <option selected :value="null">Chọn tất cả</option>
                  <option :value="true">Đang mở bán</option>
                  <option :value="false">Tạm ngưng</option>
                </select>
              </div>
              <div class="col-md-2">
                <h5> &ensp;</h5>
                <button type="button" @click="getDataDetail(apartDetail.idApartment)" class="btn btn btn-primary">Tìm
                  Kiếm</button>
              </div>

            </div>

            <div class="mx-auto shadow-lg p-3 rounded" style="overflow-y: scroll; height: 500px;">
              <table class=" table rounded">
                <thead class="">
                  <tr>
                    <th scope="col">Hình ảnh căn hộ</th>
                    <th style="width: 10%;" scope="col">Tên Phòng</th>
                    <th scope="col">Diện tích</th>
                    <th scope="col" @click="updatSort()" class="sort-price">Giá 
                      <span v-if="isSortLowToHighRoom">
                        <svg xmlns="http://www.w3.org/2000/svg" width="26" height="26" fill="currentColor"
                          class="bi bi-sort-numeric-down" viewBox="0 0 16 16">
                          <path d="M12.438 1.668V7H11.39V2.684h-.051l-1.211.859v-.969l1.262-.906h1.046z" />
                          <path fill-rule="evenodd"
                            d="M11.36 14.098c-1.137 0-1.708-.657-1.762-1.278h1.004c.058.223.343.45.773.45.824 0 1.164-.829 1.133-1.856h-.059c-.148.39-.57.742-1.261.742-.91 0-1.72-.613-1.72-1.758 0-1.148.848-1.835 1.973-1.835 1.09 0 2.063.636 2.063 2.687 0 1.867-.723 2.848-2.145 2.848zm.062-2.735c.504 0 .933-.336.933-.972 0-.633-.398-1.008-.94-1.008-.52 0-.927.375-.927 1 0 .64.418.98.934.98" />
                          <path
                            d="M4.5 2.5a.5.5 0 0 0-1 0v9.793l-1.146-1.147a.5.5 0 0 0-.708.708l2 1.999.007.007a.497.497 0 0 0 .7-.006l2-2a.5.5 0 0 0-.707-.708L4.5 12.293z" />
                        </svg>
                      </span>
                      <span v-if="!isSortLowToHighRoom">
                        <svg xmlns="http://www.w3.org/2000/svg" width="26" height="26" fill="currentColor"
                          class="bi bi-sort-numeric-up" viewBox="0 0 16 16">
                          <path d="M12.438 1.668V7H11.39V2.684h-.051l-1.211.859v-.969l1.262-.906h1.046z" />
                          <path fill-rule="evenodd"
                            d="M11.36 14.098c-1.137 0-1.708-.657-1.762-1.278h1.004c.058.223.343.45.773.45.824 0 1.164-.829 1.133-1.856h-.059c-.148.39-.57.742-1.261.742-.91 0-1.72-.613-1.72-1.758 0-1.148.848-1.835 1.973-1.835 1.09 0 2.063.636 2.063 2.687 0 1.867-.723 2.848-2.145 2.848zm.062-2.735c.504 0 .933-.336.933-.972 0-.633-.398-1.008-.94-1.008-.52 0-.927.375-.927 1 0 .64.418.98.934.98" />
                          <path
                            d="M4.5 13.5a.5.5 0 0 1-1 0V3.707L2.354 4.854a.5.5 0 1 1-.708-.708l2-1.999.007-.007a.5.5 0 0 1 .7.006l2 2a.5.5 0 1 1-.707.708L4.5 3.707z" />
                        </svg>
                      </span>

                    </th>


                    <th scope="col">Trạng thái</th>
                    <th scope="col">Thao Tác</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="room in apartDetail.listRoom" :key="room.idRoom">
                    <th scope="row">
                      <img
                        :src="room.image ? room.image : 'http://res.cloudinary.com/djxfzinut/image/upload/v1739845358/hvgwzmzqv0sbdqnlb35w.png'"
                        alt="">
                    </th>
                    <td>
                      {{ room.name }}
                    </td>
                    <td v-if="room.roomArea">
                      {{ room.roomArea }} m²
                    </td>
                    <td v-else>Nah</td>



                    <td >
                      {{ room.priceRoomDay.toLocaleString('vi-VN',
                      {
                        style: 'currency', currency: 'VND'
                      }) }} / ngày
                      <br>
                      {{ room.priceRoomMonth.toLocaleString('vi-VN',
                      {
                        style: 'currency', currency: 'VND'
                      }) }} / Tháng
                    </td>
             
                    <td>
                      <span v-if="!room.isAvailable" class="text-danger">Tạm khoá</span>
                      <span v-if="room.isAvailable" class="text-primary">Đang có sẵn</span>
                    </td>
                    <td>
                      <button type="button" data-bs-toggle="modal"
                        @click="changeModalCurrentRoom('update'), getDataUpdate(room.idRoom)"
                        data-bs-target="#exampleModal" class="btn btn-outline-secondary me-1">Cập
                        nhật</button>
                    </td>
                  </tr>

                </tbody>

              </table>
            </div>


            <div class="w-100 my-3 d-flex justify-content-center ">
              <nav class="mx-auto text-center " aria-label="...">
                <ul class="pagination">
                  <li class="page-item ">
                    <button @click="pagingRoom(pageRoom - 1)" :disabled="pageRoom == 0"
                      class="page-link">Previous</button>
                  </li>
                  <li v-if="pageRoom > 0" class="page-item ">
                    <button @click="pagingRoom(pageRoom - 1)" class="page-link">{{
                      pageRoom }} </button>
                  </li>
                  <li class="page-item active">
                    <button class="page-link">{{ pageRoom + 1 }} </button>
                  </li>
                  <li v-if="totalPagesRoom - 1 > pageRoom > 0" class="page-item ">
                    <button @click="pagingRoom(pageRoom + 1)" class="page-link">{{
                      pageRoom + 2 }} </button>
                  </li>

                  <li class="page-item">
                    <button @click="pagingRoom(pageRoom + 1)" :disabled="pageRoom == totalPagesRoom - 1"
                      class="page-link">Next</button>
                  </li>
                </ul>
              </nav>
            </div>

          </div>

        </div>
      </div>
    </div>
    <!-- modal add apartment -->

    <!-- Modal -->
    <div class="modal fade modal-lg" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel"
      aria-hidden="true" data-bs-backdrop="static" data-bs-keyboard="false">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h1 class="modal-title fs-5" id="exampleModalLabel">Thêm sản phẩm</h1>
            <button type="button" @click="refreshForm()" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">

            <form action="" @submit.prevent="submitForm" enctype="multipart/form-data">
              <div class="w-100 h-100 p-3 ">
                <div class=" row ms-auto ">

                  <div class="col-4">
                    <label for="inputAddress" class="form-label">&ensp;</label>
                    <img
                      :src="imgApartToShow ? imgApartToShow : 'http://res.cloudinary.com/djxfzinut/image/upload/v1739845358/hvgwzmzqv0sbdqnlb35w.png'"
                      class="img-thumbnail border mx-auto" id="previewImage" alt="." style="height: 200px; width: 100%">

                    <div class="input-group my-3 ">
                      <input type="file" @change="changeImgApart" class="form-control" id="fileInput">
                    </div>

                  </div>
                  <div class="col-7 row ">
                    <div class="col-12">
                      <label for="inputAddress" class="form-label">Tên phòng</label>
                      <input type="text" v-model="formData.nameRoom" class="form-control" id="inputAddress"
                        placeholder="">
                      <p v-if="errors.nameRoom" style="color: red">{{ errors.nameRoom }}</p>
                    </div>
                    <div class="col-12">
                      <label for="inputAddress" class="form-label">Diện tích (<i class="fas fa-ruler-combined"></i> m²
                        )</label>
                      <input type="number" v-model="formData.roomArea" class="form-control" id="inputAddress"
                        placeholder="">
                      <p v-if="errors.roomArea" style="color: red">{{ errors.roomArea }}</p>
                    </div>
                    <div class="col-6">
                      <label for="inputAddress" class="form-label">Giá theo ngày</label>
                      <input type="number" v-model="formData.priceRoomDay" class="form-control" id="inputAddress"
                        placeholder="">
                      <p v-if="errors.priceRoomDay" style="color: red">{{ errors.priceRoomDay }}</p>
                    </div>
                    <div class="col-6">
                      <label for="inputAddress" class="form-label">Giá theo tháng</label>
                      <input type="number" v-model="formData.priceRoomMonth" class="form-control" id="inputAddress"
                        placeholder="">
                      <p v-if="errors.priceRoomMonth" style="color: red">{{ errors.priceRoomMonth }}</p>
                    </div>

                    <div class="col-md-12">
                      <label for="inputPassword4" class="form-label">Trạng thái</label>
                      <select class="form-select" v-model="formData.statusApart" formControlName="isSelling"
                        aria-label="Default select example">
                        <option selected :value="true">True</option>
                        <option :value="false">False</option>
                      </select>


                    </div>
                    <div class="col-md-12">


                    </div>
                  </div>
                  <div class=" col-12  form-floating">
                    <textarea class="form-control" v-model="formData.description" style="height: 150px"
                      placeholder="Leave a comment here" id="floatingTextarea"></textarea>
                    <label for="floatingTextarea">Mô tả</label>
                  </div>
                  <div class="col-12 w-100 mt-2 text-center">
                    <button type="button" v-if="currentModal == 'add'" @click="testPost()"
                      class="btn btn-outline-primary mx-2">Thêm Phòng</button>
                    <button type="button" formmethod="patch" @click="patchApart()"
                      v-if="currentModal == 'update'" class="btn btn-outline-primary mx-2">Sửa Phòng</button>
                    <!-- <button type="button"  formmethod="delete" class="btn btn-outline-primary mx-2">Xoá Căn hộ</button> -->
                    <button type="button" @click="refreshForm()" class="btn btn-outline-primary mx-2">Làm mới</button>
                    <button type="button" v-if="currentModal == 'update'" @click="deleteRoom()" class="btn btn-outline-danger mx-2">Xoá phòng</button>
                  </div>



                </div>


              </div>
            </form>


          </div>

        </div>
      </div>
    </div>

  </div>
</template>

<script>
import axios from 'axios';
import config from "@/config.js";
export default {
  name: "RoomComponent",
  data() {
    return {// room and apartment detail
      apartDetail: {
        idApartment: null,
        name: null,
        address: null,
        isAvailable: null,
        listRoom: []
      },
      loading: false,
      nameRoom: null,
      statusRoom: null,
      pageRoom: 0,
      sizePageRoom: 0,
      isSortLowToHighRoom: true,
      totalPagesRoom: null,
      // add apartment
      formData: {
        nameRoom: "",
        priceRoomDay: "",
        priceRoomMonth: "",
        statusApart: true,
        imgApart: null,
        roomArea: "",
        description: "",
      },
      initialValues: {
        nameRoom: "",
        priceRoomDay: "",
        priceRoomMonth: "",
        statusApart: true,
        imgApart: null,
        roomArea: "",
        description: "",
      },
      errors: {},
      imgApartToShow: null,
      currentModal: "",
      // room and apartment detail
    };
  },
  computed: {
    apartDetailParam() {
      return this.$route.query.apartDetailParam ? JSON.parse(this.$route.query.apartDetailParam) : {};
    },
  },
  mounted() {
    this.getDataDetail(this.apartDetailParam);
  },
  methods: {
    // room and apartment detail
    getDataDetail(idApartment) {



      axios.get(`${config.API_URL}/apartments/` + this.apartDetailParam,
      )
        .then(response => {
          this.apartDetail.idApartment = response.data.result.idApartment,
            this.apartDetail.name = response.data.result.name,
            this.apartDetail.address = response.data.result.address,
            this.apartDetail.isAvailable = response.data.result.isAvailable,
            this.apartDetail.image = response.data.result.image
          console.log();


        })
        .catch(error => {
          console.error('Có lỗi khi gọi API:', error);
        });




      axios.get(`${config.API_URL}/rooms/filter`,
        {
          params: {
            nameOrAddress: this.nameRoom,
            isAvailable: this.statusRoom,
            idApartment: idApartment,
            page: this.pageRoom,
            sizePage: 5,
            isSortLowToHigh: this.isSortLowToHighRoom
          }
        }
      )
        .then(response => {
          this.apartDetail.listRoom = response.data.result.content;
          this.totalPagesRoom = response.data.result.totalPages
        })
        .catch(error => {
          console.error('Có lỗi khi gọi API:', error);
        });

    },
    pagingRoom(params) {
      this.pageRoom = params;
      this.getDataDetail(this.apartDetail.idApartment);
    },
    changeImgApart(event) {
      this.formData.imgApart = event.target.files[0];
      this.imgApartToShow = URL.createObjectURL(this.formData.imgApart)
      console.log("File selected:", this.formData.imgApart);
    },

    validateForm() {
      let checkValid = true;
      this.errors = {};

      if (!this.formData.nameRoom.trim()) {
        this.errors.nameRoom = "Name is required.";
        checkValid = false;
      } else if (this.formData.nameRoom.length < 1) {
        this.errors.nameRoom = "Name must be at least 1 characters.";
        checkValid = false;
      }

      if (!this.formData.priceRoomDay) {
        this.errors.priceRoomDay = "price Room  is required.";
        checkValid = false;
      } else if (this.formData.priceRoomDay < 1) {
        this.errors.priceRoomDay = "price Room must be at least 1 .";
        checkValid = false;
      }

      if (!this.formData.priceRoomMonth) {
        this.errors.priceRoomMonth = "price Room  is required.";
        checkValid = false;
      } else if (this.formData.priceRoomMonth < 1) {
        this.errors.priceRoomMonth = "price Room must be at least 1 .";
        checkValid = false;
      }

      if (!this.formData.roomArea) {
        this.errors.roomArea = "roomArea Room  is required.";
        checkValid = false;
      } else if (this.formData.roomArea < 1) {
        this.errors.roomArea = "roomArea Room must be at least 1 .";
        checkValid = false;
      }

      return checkValid;
    },
    async testPost() {
      if (!this.validateForm()) { return false }
      const formData = new FormData();
      formData.append("name", this.formData.nameRoom);
      formData.append("priceRoomDay", this.formData.priceRoomDay);
      formData.append("priceRoomMonth", this.formData.priceRoomMonth);
      formData.append("roomArea", this.formData.roomArea);
      formData.append("isAvailable", this.formData.statusApart);
      formData.append("idApartment", this.apartDetailParam);
      formData.append("description", this.formData.description);
      this.loading = true;
      if (this.formData.imgApart) {
        formData.append("imageFile", this.formData.imgApart);
      }
      axios.post(`${config.API_URL}/rooms`, formData, {
        headers: { "Content-Type": "multipart/form-data" }
      }
      ).then(response => {
        this.apartments = response.data.result.content;
        console.log("hello");
        console.log(response.data);
        this.$toast.success('Success message!');
        this.getDataDetail(this.apartDetailParam);
        this.loading = false;
        this.refreshForm()

      })
        .catch(error => {
          console.error('Có lỗi khi gọi API:', error);
          this.loading = false;
          this.$toast.error('Error message!');
        });
    },

    changeModalCurrentRoom(params) {
      console.log("xxxxxxxxxxxxxxxxxx");

      this.currentModal = params;
    },

    getDataUpdate(idRoom) {
      this.apartDetail.listRoom.forEach((element) => {
        if (element.idRoom == idRoom) {
          console.log(element);

          this.initialValues = {
            idRoom: idRoom,
            nameRoom: element.name,
            priceRoomDay: element.priceRoomDay,
            priceRoomMonth: element.priceRoomMonth,
            statusApart: element.isAvailable,
            imgApart: element.image,
            roomArea: element.roomArea,
            description: element.description,
          }
          this.imgApartToShow = element.image
          this.formData = {
            nameRoom: element.name,
            priceRoomDay: element.priceRoomDay,
            priceRoomMonth: element.priceRoomMonth,
            statusApart: element.isAvailable,
            imgApart: element.image,
            roomArea: element.roomArea,
            description: element.description,
          }
        }
      })
      console.log(this.formData);
      

    },

    async patchApart() {
      if (!this.validateForm()) { return false }
      const formData = new FormData();
      if (this.formData.nameRoom != this.initialValues.nameRoom) {
        formData.append("name", this.formData.nameRoom);
      }
      if (this.formData.statusApart != this.initialValues.statusApart) {
        formData.append("isAvailable", this.formData.statusApart);
      }
      if (this.formData.roomArea != this.initialValues.roomArea) {
        formData.append("roomArea", this.formData.roomArea);
      }
      if (this.formData.description != this.initialValues.description) {
        formData.append("description", this.formData.description);
      }
      if (this.formData.priceRoomDay != this.initialValues.priceRoomDay) {
        formData.append("priceRoomDay", this.formData.priceRoomDay);
      }
      if (this.formData.priceRoomMonth != this.initialValues.priceRoomMonth) {
        formData.append("priceRoomMonth", this.formData.priceRoomMonth);
      }
      if (this.formData.imgApart) {
        formData.append("imageFile", this.formData.imgApart);
      }
      this.loading = true;
      axios.patch(`${config.API_URL}/rooms/` + this.initialValues.idRoom, formData, {
        headers: { "Content-Type": "multipart/form-data" }
      }
      ).then(response => {
        this.apartments = response.data.result.content;
        console.log("hello");
        console.log(response.data);
        this.$toast.success('Success message!');
        this.getDataDetail(this.apartDetailParam);
        this.loading = false;
        this.refreshForm()

      })
        .catch(error => {
          console.error('Có lỗi khi gọi API:', error);
          this.$toast.error('Error message!');
          this.loading = false;
        });
    },

    deleteRoom(){
      axios.delete(`${config.API_URL}/rooms/` + this.initialValues.idRoom, {
        headers: { "Content-Type": "multipart/form-data" }
      }
      ).then(() => {
     
        this.$toast.success('Success message!');
        this.getDataDetail(this.apartDetailParam);
        this.loading = false;
        this.refreshForm()

      })
        .catch(error => {
          console.error('Có lỗi khi gọi API:', error);
          this.$toast.error('Error message!');
          this.loading = false;
        });
    },
    refreshForm(){
      this.formData = {
        nameRoom: "",
        priceRoomDay: "",
        priceRoomMonth: "",
        statusApart: true,
        imgApart: null,
        roomArea: "",
        description: "",
      }
      this.errors = {};
      this.imgApartToShow = null;
    },
    updatSort(){
      this.isSortLowToHighRoom = !this.isSortLowToHighRoom;
      this.getDataDetail(this.apartDetailParam);
    }


  }

}
</script>

<style>
.loading-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 9999;
}

.spinner-border {
  width: 4rem;
  height: 4rem;
}
</style>