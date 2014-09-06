using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Pyramidion.DataAccess;
using System.Data;

namespace Pyramidion.Controllers
{
	/// <summary>
	/// This is a sample Trident API Service partial implementation using Visual Studio / MVC. 
	/// You can implement similar service calls in whatever environment you prefer (Node/php/etc).
	/// This example uses LINQ on entity framework CodeFirst classes and should demonstrate 
	/// services, parameters, and return values.
	/// </summary>
    public class KeystoreController : Controller
    {
        private PyramidionContext db = new PyramidionContext();

        [ValidateInput(false)]
        public ActionResult SetKey(string App, string Key, string Val)
        {
            Quanta q = (from qt in db.Quantum where qt.App == App && qt.Key == Key select qt).FirstOrDefault();

            if (q == null)
            {
                q = new Quanta();
                
                q.App = App;
                q.Key = Key;
                q.Val = Val;

                db.Quantum.Add(q);
            }
            else
            {
                q.App = App;
                q.Key = Key;
                q.Val = Val;

                db.Entry(q).State = EntityState.Modified;
            }

            db.SaveChanges();

            return Json(new { success = true, id = q.ID }, "application/json");
        }

        public ActionResult GetKey(string App, string Key)
        {
            Quanta q = (from qt in db.Quantum where qt.App == App && qt.Key == Key select qt).FirstOrDefault();

            if (q == null)
            {
                return Json(new { id = 0, app = "", key = "", val = "" }, "application/json");
            }

            return Json(new { id = q.ID, app = q.App, key = q.Key, val = q.Val }, "application/json");
        }

        public ActionResult GetAppKeys(string App)
        {
            var q = (from qt in db.Quantum where qt.App == App select new { id = qt.ID, app = qt.App, key = qt.Key }).ToArray();

            return Json(q, "application/json");
        }

        public ActionResult GetAllKeys()
        {
            var q = (from qt in db.Quantum select new { id = qt.ID, app = qt.App, key = qt.Key }).OrderBy(qt => qt.app).ToArray();

            return Json(q, "application/json");
        }

        public ActionResult GetKeyById(int id)
        {
            Quanta q = db.Quantum.Find(id);

            return Json(new { id = q.ID, app = q.App, key = q.Key, val = q.Val }, "application/json");
        }

        public ActionResult RemoveKey(int id)
        {
            Quanta q = db.Quantum.Find(id);

            db.Quantum.Remove(q);
            db.SaveChanges();

            return Json(new { success = true }, "application/json");
        }

    }
}
