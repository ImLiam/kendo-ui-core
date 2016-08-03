﻿using System;
using System.Linq;
using System.Web.Mvc;
using Kendo.Mvc.Examples.Models;

namespace Kendo.Mvc.Examples.Controllers
{
    public partial class Bubble_ChartsController : Controller
    {
        [Demo]
        public ActionResult Remote_Data_Binding()
        {
            return View();
        }

        [HttpPost]
        public ActionResult _CrimeStats()
        {
            return Json(ChartDataRepository.CrimeStats());
        }
    }
}