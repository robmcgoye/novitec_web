import { Controller } from "@hotwired/stimulus";

import Swiper from "swiper";
import { Navigation, Pagination, Autoplay } from "swiper/modules";

Swiper.use([Navigation, Pagination, Autoplay]);

export default class extends Controller {
  connect() {
    // console.log("CarouselController connected");
    this.swiper = new Swiper(this.element, {
      loop: true,
      autoplay: { delay: 3000 },
      pagination: { el: ".swiper-pagination", clickable: true },
      navigation: { nextEl: ".swiper-button-next", prevEl: ".swiper-button-prev" }
    });
  }
}
