<template>
    <div class="body-apartment container-fluid py-2">

        <!-- loading -->
    <div v-if="loading" class="loading-overlay">
      <div class="spinner-border text-light"></div>
    </div>

        <!-- <router-link to="/rooms">Test</router-link> | -->
        <div class="bg-header">
            <div class="d-flex justify-content-between container-fluid  ">
                <h2 class="text-primary">Quản lý căn hộ / phòng </h2>
                <button type="button" @click="changeModalCurrentApart('add')" class="btn btn btn-primary"
                    data-bs-toggle="modal" data-bs-target="#exampleModal">+ Thêm căn hộ</button>
            </div>

            <div class="d-flex justify-content-between container-fluid  mt-1">
                <h3 class="">Tổng số căn hộ <strong class="">{{ totalApartment }}</strong> </h3>

            </div>

            <div class="d-flex row container  ">
                <div class="col-md-4">
                    <h5>Tìm theo tên / địa chỉ</h5>
                    <div class="input-group mb-1 ">
                        <span class="input-group-text " id="basic-addon1">&#128269;
                        </span>
                        <input type="text" v-model="nameOrLocation" @keydown.enter="fillList()"
                            class="form-control input-search " placeholder="Search" aria-label="Username"
                            aria-describedby="basic-addon1">

                    </div>
                </div>
     
                <div class="col-md-3">
                    <h5>Trạng thái</h5>
                    <select id="inputState" v-model="status" class="form-select" name="isSellingFilter">
                        <option selected :value="null">Chọn tất cả</option>
                        <option value="true">Đang mở bán</option>
                        <option value="false">Tạm ngưng</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <h5> &ensp;</h5>
                    <button type="button" @click="fillList()" class="btn btn btn-primary">Tìm Kiếm</button>
                </div>

            </div>
        </div>
        <div class="mx-auto" style="overflow-y: scroll; height: 500px;">
            <table class=" table rounded">
                <thead class="">
                    <tr>
                        <th scope="col">Hình ảnh căn hộ</th>
                        <th scope="col">ID | Tên toà nhà | Địa Chỉ</th>
                        <th scope="col">Loại </th>
                        
                        <th scope="col">Trạng thái</th>
                        <th scope="col">Thao Tác</th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-for="element in apartments" :key="element.idApartment">
                        <th scope="row">
                            <img :src="element.image ? element.image : 'http://res.cloudinary.com/djxfzinut/image/upload/v1739845358/hvgwzmzqv0sbdqnlb35w.png'"
                                alt="">
                        </th>
                        <td class="info-apartment">
                            ID : {{ element.idApartment }} | {{ element.name }} | {{ element.address }}
                        </td>
                        <td>{{ element.isTheWholeHouse ? 'Nguyên căn' : 'Phòng lẻ' }}</td>
                       
                        <td>
                            <span v-if="!element.isAvailable" class="text-danger">Tạm khoá</span>
                            <span v-if="element.isAvailable" class="text-primary">Đang có sẵn</span>
                        </td>
                        <td>
                            <button type="button"
                                @click="changeModalCurrentApart('update'), getDataUpdate(element.idApartment)"
                                data-bs-toggle="modal" data-bs-target="#exampleModal"
                                class="btn btn-outline-secondary me-1">Cập nhật</button>
                            <button type="button" class="btn btn-outline-primary"
                                @click="getDataDetail(element.idApartment)" ><i class="fas fa-eye"></i> Chi
                                Tiết</button>
                        </td>
                    </tr>

                </tbody>

            </table>
        </div>

        <div class="w-100 my-3 d-flex justify-content-center ">
            <nav class="mx-auto text-center " aria-label="...">
                <ul class="pagination">
                    <li class="page-item ">
                        <button @click="paging(number - 1)" :disabled="number == 0" class="page-link">Previous</button>
                    </li>
                    <li v-if="number > 0" class="page-item ">
                        <button @click="paging(number - 1)" class="page-link">{{ number }} </button>
                    </li>
                    <li class="page-item active">
                        <button class="page-link">{{ number + 1 }} </button>
                    </li>
                    <li v-if="totalPages - 1 > number > 0" class="page-item ">
                        <button @click="paging(number + 1)" class="page-link">{{ number + 2 }} </button>
                    </li>

                    <li class="page-item">
                        <button @click="paging(number + 1)" :disabled="number == totalPages - 1"
                            class="page-link">Next</button>
                    </li>
                </ul>
            </nav>
        </div>

        <!-- modal add apartment -->

        <!-- Modal -->
        <div class="modal fade modal-lg" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel"
            aria-hidden="true" data-bs-backdrop="static" data-bs-keyboard="false">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h1 class="modal-title fs-5" id="exampleModalLabel">Thêm sản phẩm</h1>
                        <button type="button" @click="refreshForm()" class="btn-close" data-bs-dismiss="modal"
                            aria-label="Close"></button>
                    </div>
                    <div class="modal-body">

                        <form action="" @submit.prevent="submitForm" enctype="multipart/form-data">
                            <div class="w-100 h-100 p-3 ">
                                <div class=" row ms-auto ">

                                    <div class="col-4">
                                        <label for="inputAddress" class="form-label">&ensp;</label>
                                        <!-- <img *ngIf="srcImage!='./img/noImage.jpg'" id="previewImage" class="img-thumbnail border mx-auto" alt="" src="http://localhost:8080/images/{{srcImage}}" style="height: 200px; width: 100%">
      <img *ngIf="srcImage=='./img/noImage.jpg'" id="previewImage" class="img-thumbnail border mx-auto" alt="" src="{{srcImage}}" style="height: 200px; width: 100%"> -->
                                        <img :src="imgApartToShow ? imgApartToShow : 'http://res.cloudinary.com/djxfzinut/image/upload/v1739845358/hvgwzmzqv0sbdqnlb35w.png'"
                                            class="img-thumbnail border mx-auto" id="previewImage" alt="."
                                            style="height: 200px; width: 100%">

                                        <div class="input-group my-3 ">
                                            <input type="file" @change="changeImgApart" class="form-control"
                                                id="fileInput">
                                        </div>

                                    </div>
                                    <div class="col-7 row ">
                                        <div class="col-12">
                                            <label for="inputAddress" class="form-label">Tên căn hộ</label>
                                            <input type="text" v-model="formData.nameApart" class="form-control"
                                                id="inputAddress" placeholder="">
                                            <p v-if="errors.nameApart" style="color: red">{{ errors.nameApart }}</p>
                                        </div>
                                        <div class="col-12">
                                            <label for="inputAddress" class="form-label">Địa chỉ</label>
                                            <input type="text" v-model="formData.locateApart" class="form-control"
                                                id="inputAddress" placeholder="">
                                            <p v-if="errors.locateApart" style="color: red">{{ errors.locateApart }}</p>
                                        </div>

                                        <!-- <div class="col-12">
        <label for="inputAddress" class="form-label">Loại sản phẩm </label>
        <select class="form-select" formControlName="idCategory" aria-label="Default select example">
          <option  >cccc</option>
        </select>
        </div> -->

                                        <!-- <div class="col-md-6">
          <label for="inputEmail4"  class="form-label">Đơn Giá</label>
          <input type="number" formControlName="priceFood"   class="form-control" id="inputEmail4">
     
        </div>
        <div class="col-md-6">
          <label for="inputEmail4"  class="form-label">Giảm Giá</label>
          <input type="number" formControlName="discount" placeholder="%"   class="form-control" id="inputEmail4">
           
        </div> -->

                                        <div class="col-md-12">
                                            <label for="inputPassword4" class="form-label">Trạng thái(Đang bán)</label>
                                            <select class="form-select" v-model="formData.statusApart"
                                                formControlName="isSelling" aria-label="Default select example">
                                                <option selected :value="true">True</option>
                                                <option :value="false">False</option>
                                            </select>


                                        </div>
                                    </div>
                                    <!-- <div class="col-12">
      <div class="mb-3">
        <label for="exampleFormControlTextarea1"  class="form-label">Mô tả</label>
        <textarea class="form-control" formControlName="note" id="exampleFormControlTextarea1" rows="5"></textarea>
      </div>
    </div> -->

                                    <div class="col-12 w-100 mt-2 text-center">
                                        <button type="button" @click="testPost(), refreshForm()"
                                            v-if="currentModal == 'add'" class="btn btn-outline-primary mx-2"
                                            data-bs-dismiss="modal" aria-label="Close">Thêm Căn hộ</button>
                                        <button type="button" formmethod="patch" @click="patchApart(), refreshForm()"
                                            v-if="currentModal == 'update'" class="btn btn-outline-primary mx-2"
                                            data-bs-dismiss="modal" aria-label="Close">Sửa Căn hộ</button>
                                        <!-- <button type="button"  formmethod="delete" class="btn btn-outline-primary mx-2">Xoá Căn hộ</button> -->
                                        <button type="button" @click="refreshForm()"
                                            class="btn btn-outline-primary mx-2">Làm mới</button>
                                    </div>

                                </div>


                            </div>
                        </form>


                    </div>
                    <!-- <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
        <button type="button" class="btn btn-primary">Save changes</button>
      </div> -->
                </div>
            </div>
        </div>


        <!--------------------------------------------------- Modal detail------------------------------------------->
        <div class="modal fade modal-xl" id="ModalDetail" tabindex="-1" aria-labelledby="exampleModalLabel"
            aria-hidden="true" data-bs-backdrop="static" data-bs-keyboard="false">
            <div class="modal-dialog modal-fullscreen">
                <div class="modal-content">
                    <div class="modal-header">
                        <h1 class="modal-title fs-5" id="exampleModalLabel">Căn hộ </h1>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="w-100 h-100 p-1 ">
                            <div class=" row ms-auto ">

                                <div class="col-3">
                                    <img :src="apartDetail.image ? apartDetail.image : 'http://res.cloudinary.com/djxfzinut/image/upload/v1739845358/hvgwzmzqv0sbdqnlb35w.png'"
                                        class="img-thumbnail border mx-auto" id="previewImage" alt="."
                                        style="height: 200px; width: 100%">
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
                                            <h4 for="inputPassword4" class="form-label">Trạng thái(Đang bán) : {{
                                                apartDetail.isAvailable ? 'Đang có sẵn' : 'Tạm khoá' }} </h4>
                                        </div>
                                        <div class="col-3">
                                            <button type="button" class="me-2 btn btn-primary"
                                            data-bs-toggle="offcanvas" data-bs-target="#offcanvasBottom" aria-controls="offcanvasBottom"
                                            > + Thêm phòng</button>
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
                                                <input type="text" class="form-control input-search " v-model="nameRoom"
                                                    placeholder="Search" aria-label="Username"
                                                    aria-describedby="basic-addon1">

                                            </div>
                                        </div>
                                       
                                        <div class="col-md-3">
                                            <h5>Trạng thái</h5>
                                            <select id="inputState" v-model="statusRoom" class="form-select"
                                                name="isSellingFilter">
                                                <option selected :value="null">Chọn tất cả</option>
                                                <option :value="true">Đang mở bán</option>
                                                <option :value="false">Tạm ngưng</option>
                                            </select>
                                        </div>
                                        <div class="col-md-2">
                                            <h5> &ensp;</h5>
                                            <button type="button" @click="getDataDetail(apartDetail.idApartment)"
                                                class="btn btn btn-primary">Tìm Kiếm</button>
                                        </div>

                                    </div>

                                    <div class="mx-auto shadow-lg p-3 rounded"
                                        style="overflow-y: scroll; height: 500px;">
                                        <table class=" table rounded">
                                            <thead class="">
                                                <tr>
                                                    <th scope="col">Hình ảnh căn hộ</th>
                                                    <th scope="col">ID | Tên toà nhà | Địa Chỉ</th>
                                                    <th scope="col">Loại </th>
                                                    <th scope="col" class="sort-price" @click="sortPrice()">Giá cả
                                                        <span v-if="isSortLowToHigh">
                                                            <svg xmlns="http://www.w3.org/2000/svg" width="26"
                                                                height="26" fill="currentColor"
                                                                class="bi bi-sort-numeric-down" viewBox="0 0 16 16">
                                                                <path
                                                                    d="M12.438 1.668V7H11.39V2.684h-.051l-1.211.859v-.969l1.262-.906h1.046z" />
                                                                <path fill-rule="evenodd"
                                                                    d="M11.36 14.098c-1.137 0-1.708-.657-1.762-1.278h1.004c.058.223.343.45.773.45.824 0 1.164-.829 1.133-1.856h-.059c-.148.39-.57.742-1.261.742-.91 0-1.72-.613-1.72-1.758 0-1.148.848-1.835 1.973-1.835 1.09 0 2.063.636 2.063 2.687 0 1.867-.723 2.848-2.145 2.848zm.062-2.735c.504 0 .933-.336.933-.972 0-.633-.398-1.008-.94-1.008-.52 0-.927.375-.927 1 0 .64.418.98.934.98" />
                                                                <path
                                                                    d="M4.5 2.5a.5.5 0 0 0-1 0v9.793l-1.146-1.147a.5.5 0 0 0-.708.708l2 1.999.007.007a.497.497 0 0 0 .7-.006l2-2a.5.5 0 0 0-.707-.708L4.5 12.293z" />
                                                            </svg>
                                                        </span>
                                                        <span v-if="!isSortLowToHigh">
                                                            <svg xmlns="http://www.w3.org/2000/svg" width="26"
                                                                height="26" fill="currentColor"
                                                                class="bi bi-sort-numeric-up" viewBox="0 0 16 16">
                                                                <path
                                                                    d="M12.438 1.668V7H11.39V2.684h-.051l-1.211.859v-.969l1.262-.906h1.046z" />
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
                                                        <img :src="room.image ? room.image : 'http://res.cloudinary.com/djxfzinut/image/upload/v1739845358/hvgwzmzqv0sbdqnlb35w.png'"
                                                            alt="">
                                                    </th>
                                                    <td class="info-apartment">
                                                        ID : {{ room.idRoom }} | {{ room.name }}
                                                    </td>

                                                    <td v-if="room.priceRoom">{{ room.priceRoom.toLocaleString('vi-VN',
                                                        {
                                                        style: 'currency', currency: 'VND'
                                                        }) }} / Tháng</td>
                                                    <td v-else></td>
                                                    <td>{{ room.isAvailable ? 'Đang có sẵn' : 'Tạm khoá' }}</td>
                                                    <td>
                                                        <button type="button" class="btn btn-outline-secondary me-1">Cập
                                                            nhật</button>
                                                        <button type="button" class="btn btn-outline-primary"><i
                                                                class="fas fa-eye"></i> Chi
                                                            Tiết</button>
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
                                                    <button @click="pagingRoom(pageRoom + 1)"
                                                        :disabled="pageRoom == totalPagesRoom - 1"
                                                        class="page-link">Next</button>
                                                </li>
                                            </ul>
                                        </nav>
                                    </div>

                                </div>

                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>



    </div>
</template>
<script>
import axios from 'axios';
import { ref } from 'vue';
import config from "@/config.js";
export default {
    name: "ApartmentVue",
    data() {
        return {
            apartments: ref([]),
            totalApartment: 0,
            number: 0,
            totalPages: 0,
            isSortLowToHigh: true,
            type: null,
            status: null,
            nameOrLocation: null,
            currentModal: "",
            loading: false,
            // add apartment
            formData: {
                nameApart: "",
                locateApart: "",
                statusApart: true,
                imgApart: null,
            },
            initialValues: {
                nameApart: "",
                locateApart: "",
                statusApart: true,
            },
            errors: {},
            imgApartToShow: null,
            formMethod: "post",
            // room and apartment detail
            apartDetail: {
                idApartment: null,
                name: null,
                address: null,
                isAvailable: null,
                listRoom: []
            },
            nameRoom: null,
            statusRoom: null,
            pageRoom: 0,
            sizePageRoom: 0,
            isSortLowToHighRoom: true,
            totalPagesRoom: null,
        };
    },
    mounted() {
        this.fillList();

    },
    methods: {

        fillList() {

            axios.get(`${config.API_URL}/apartments/filter`,
                {
                    params: {
                        isTheWholeHouse: this.type,
                        isAvailable: this.status,
                        nameOrAddress: this.nameOrLocation,
                        page: this.number,
                        sizePage: 5,
                        isSortLowToHigh: this.isSortLowToHigh
                    }
                }
            )
                .then(response => {
                    this.apartments = response.data.result.content;
                    console.log("hello");
                    console.log(response.data);
                    this.totalApartment = response.data.result.totalElements
                    this.totalPages = response.data.result.totalPages
                })
                .catch(error => {
                    console.error('Có lỗi khi gọi API:', error);
                });


        },

        paging(params) {
            this.number = params;
            this.fillList();
        },
        test() {

            console.log(this.nameOrLocation);
            console.log(this.type);
        },
        sortPrice() {
            this.isSortLowToHigh = !this.isSortLowToHigh;
            this.fillList();
        },
        changeImgApart(event) {
            this.formData.imgApart = event.target.files[0];
            this.imgApartToShow = URL.createObjectURL(this.formData.imgApart)
            console.log("File selected:", this.formData.imgApart);
        },
        validateForm() {
            let checkValid = true;
            this.errors = {};

            if (!this.formData.nameApart.trim()) {
                this.errors.nameApart = "Name is required.";
                checkValid = false;
            } else if (this.formData.nameApart.length < 5) {
                this.errors.nameApart = "Name must be at least 5 characters.";
                checkValid = false;
            }

            if (!this.formData.locateApart.trim()) {
                this.errors.locateApart = "Location is required.";
                checkValid = false;
            } else if (this.formData.locateApart.length < 3) {
                this.errors.locateApart = "Location must be at least 3 characters.";
                checkValid = false;
            }

            return checkValid;
        },
        async testPost() {
            if (!this.validateForm()) { return false }
            const formData = new FormData();
            formData.append("name", this.formData.nameApart);
            formData.append("address", this.formData.locateApart);
            formData.append("isAvailable", this.formData.statusApart);
            formData.append("isTheWholeHouse", true);
            this.loading = true;
            if (this.formData.imgApart) {
                formData.append("imageFile", this.formData.imgApart);
            }
            axios.post(`${config.API_URL}/apartments`, formData, {
                headers: { "Content-Type": "multipart/form-data" }
            }
            ).then(response => {
                this.apartments = response.data.result.content;
                console.log("hello");
                console.log(response.data);
                this.$toast.success('Success message!');
                this.fillList();
                this.loading = false;

            })
                .catch(error => {
                    console.error('Có lỗi khi gọi API:', error);
                    this.$toast.error('Error message!');
                    this.loading = false;
                });
        },
        refreshForm() {

            this.formData = {
                nameApart: "",
                locateApart: "",
                statusApart: true,
                imgApart: null,
            };
            this.errors = {};
            this.imgApartToShow = null;

        },
        changeModalCurrentApart(params) {
            this.currentModal = params;
        },
        getDataUpdate(idApartment) {
            console.log(idApartment)
            console.log(this.apartments);
            this.apartments.forEach((element) => {
                if (element.idApartment == idApartment) {
                    this.initialValues = {
                        idApartment: idApartment,
                        nameApart: element.name,
                        locateApart: element.address,
                        statusApart: element.isAvailable,
                    },
                        this.imgApartToShow = element.image
                }
            })
            console.log(this.initialValues);
            this.formData = {
                nameApart: this.initialValues.nameApart,
                locateApart: this.initialValues.locateApart,
                statusApart: this.initialValues.statusApart,
                imgApart: null,
            }

        },
        async patchApart() {
            if (!this.validateForm()) { return false }
            const formData = new FormData();
            if (this.formData.nameApart != this.initialValues.nameApart) {
                formData.append("name", this.formData.nameApart);
            }
            if (this.formData.locateApart != this.initialValues.locateApart) {
                formData.append("address", this.formData.locateApart);
            }
            if (this.formData.statusApart != this.initialValues.statusApart) {
                formData.append("isAvailable", this.formData.statusApart);
            }
            if (this.formData.imgApart) {
                formData.append("imageFile", this.formData.imgApart);
            }
            this.loading = true;
            axios.patch(`${config.API_URL}/apartments/` + this.initialValues.idApartment, formData, {
                headers: { "Content-Type": "multipart/form-data" }
            }
            ).then(response => {
                this.apartments = response.data.result.content;
                console.log("hello");
                console.log(response.data);
                this.$toast.success('Success message!');
                this.fillList();
                this.loading = false;

            })
                .catch(error => {
                    console.error('Có lỗi khi gọi API:', error);
                    this.$toast.error('Error message!');
                    this.loading = false;
                });
        },

        // room and apartment detail
        getDataDetail(idApartment) {
            console.log(idApartment)
            console.log(this.apartments);
            this.apartments.forEach((element) => {
                if (element.idApartment == idApartment) {

                    this.apartDetail.idApartment = idApartment,
                        this.apartDetail.name = element.name,
                        this.apartDetail.address = element.address,
                        this.apartDetail.isAvailable = element.isAvailable,
                        this.apartDetail.image = element.image
                }
            })
            console.log(this.apartDetail);
            this.goToProfile()
        },

        pagingRoom(params) {
            this.pageRoom = params;
            this.getDataDetail(this.apartDetail.idApartment);
        },
        goToProfile() {
        this.$router.push({ path: "/rooms", query: { apartDetailParam: JSON.stringify(this.apartDetail.idApartment) } });
        },


    }

}
</script>

<style>
.input-group-text {
    background-color: white;
    border-right: unset;
}

.input-search {
    border-left: unset;
}

thead {
    background-color: #4CAF50 !important;
    /* Xanh lá */
    color: white !important;
    /* Chữ trắng */
}

th img {
    width: 170px;
    height: 130px;
}

.info-apartment {
    width: 350px;
}

.sort-price {
    cursor: pointer;
}


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