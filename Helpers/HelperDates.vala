namespace SinticBolivia.Modules.Subscriptions.Helpers
{
    public class HelperDates
    {
        public static DateTime get_current_month_first_day()
        {
            var c_date = new DateTime.now_local();
            var init_date = new DateTime.local(c_date.get_year(), c_date.get_month(), 1, 0, 0, 0);
            return init_date;
        }
        public static DateTime get_current_month_last_day()
        {
            var init_date = get_current_month_first_day();
            var end_date = init_date
                .add_months(1)
                .add_days(-1)
                .add_hours(23)
                .add_minutes(59)
                .add_seconds(59);

            return end_date;
        }
        public static DateTime get_month_first_day(int year, int month)
        {
            var init_date = new DateTime.local(year, month, 1, 0, 0, 0);

            return init_date;
        }
        public static DateTime get_month_last_day(int year, int month)
        {
            var init_date = get_month_first_day(year, month);
            var end_date = init_date
                .add_months(1)
                .add_days(-1)
                .add_hours(23)
                .add_minutes(59)
                .add_seconds(59);

            return end_date;
        }
        public static DateTime get_month_last_day_from_datetime(DateTime date)
        {
            var init_date = get_month_first_day(date.get_year(), date.get_month());
            var end_date = init_date
                .add_months(1)
                .add_days(-1)
                .add_hours(23)
                .add_minutes(59)
                .add_seconds(59);

            return end_date;
        }
    }
}
