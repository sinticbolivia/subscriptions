using GLib;
static int main(string[] args)
{
    var c_date = new DateTime.now_local();
    var init_date = new DateTime.local(c_date.get_year(), c_date.get_month(), 10, 0, 0, 0);
    var end_date = init_date
        .add_months(1)
        .add_days(-1)
        .add_hours(23)
        .add_minutes(59)
        .add_seconds(59);

    print("DATE: %s\n".printf(c_date.format("%Y-%m-%d %H:%M:%S")));
    print("INIT DATE: %s\n".printf(init_date.format("%Y-%m-%d %H:%M:%S")));
    print("END DATE: %s\n".printf(end_date.format("%Y-%m-%d %H:%M:%S")));
    return 0;
}
