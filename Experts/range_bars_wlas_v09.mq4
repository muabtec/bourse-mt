#property copyright "wlas"
#property link      "http://woodiescciclub.com"
#property show_inputs

#property indicator_chart_window

#include <WinUser32.mqh>

int gi_76 = 2;
int gi_80 = 1;
int gi_84 = 0;
extern bool Enabled = TRUE;
bool gi_92 = FALSE;
extern double tick_range = 25.0;
int g_file_104 = -1;
int g_file_108 = -1;
int gi_112 = 0;
int gi_unused_116 = 0;
double gd_120;
double gd_128;
double gd_136;
double gd_144;
double gd_152;
int gi_160;
int gi_164;
int gi_168;
int gi_172 = 0;
int g_time_176 = 0;
int g_time_180 = 0;
int g_bars_184 = 0;
int g_bars_188 = 0;
int g_time_192 = 0;
int g_volume_196 = 0;
string gs_200 = "";
int gi_208 = 0;

void DebugMsg(string as_0) {
   if (gi_92) Alert(as_0);
}

int init() {
   if (gi_76 <= 1) {
      gi_76 = 1;
      gi_80 = 2;
   }
   gi_112 = Period() * gi_76;
   if (OpenHistoryFile() < 0) return (-1);
   WriteHistoryHeader();
   UpdateHistoryFile(Bars - 1, 1);
   UpdateChartWindow();
   return (0);
}

void deinit() {
   if (g_file_104 >= 0) {
      FileClose(g_file_104);
      g_file_104 = -1;
   }
   if (g_file_108 >= 0) {
      FileClose(g_file_108);
      g_file_108 = -1;
   }
}

int OpenHistoryFile() {
   string ls_0 = Symbol() + gi_112;
   if (gi_80 != 2) {
      g_file_104 = FileOpenHistory(ls_0 + ".hst", FILE_BIN|FILE_WRITE);
      if (g_file_104 < 0) return (-1);
   }
   if (gi_80 != 0) {
      g_file_108 = FileOpen(ls_0 + ".csv", FILE_CSV|FILE_WRITE, ',');
      if (g_file_108 < 0) return (-1);
   }
   return (0);
}

int WriteHistoryHeader() {
   int l_digits_8 = Digits;
   int lia_12[13] = {0};
   int li_16 = 400;
   if (g_file_104 < 0) return (-1);
   string ls_0 = "(C)opyright 2003, MetaQuotes Software Corp.";
   FileWriteInteger(g_file_104, li_16, LONG_VALUE);
   FileWriteString(g_file_104, ls_0, 64);
   FileWriteString(g_file_104, Symbol(), 12);
   FileWriteInteger(g_file_104, gi_112, LONG_VALUE);
   FileWriteInteger(g_file_104, l_digits_8, LONG_VALUE);
   FileWriteInteger(g_file_104, 0, LONG_VALUE);
   FileWriteInteger(g_file_104, 0, LONG_VALUE);
   FileWriteArray(g_file_104, lia_12, 0, ArraySize(lia_12));
   return (0);
}

void WriteHistoryData() {
   int l_digits_0;
   if (g_file_104 >= 0) {
      FileWriteInteger(g_file_104, gi_160, LONG_VALUE);
      FileWriteDouble(g_file_104, gd_120, DOUBLE_VALUE);
      FileWriteDouble(g_file_104, gd_128, DOUBLE_VALUE);
      FileWriteDouble(g_file_104, gd_136, DOUBLE_VALUE);
      FileWriteDouble(g_file_104, gd_144, DOUBLE_VALUE);
      FileWriteDouble(g_file_104, gd_152, DOUBLE_VALUE);
   }
   if (g_file_108 >= 0) {
      l_digits_0 = Digits;
      FileWrite(g_file_108, TimeToStr(gi_160, TIME_DATE), TimeToStr(gi_160, TIME_MINUTES), DoubleToStr(gd_120, l_digits_0), DoubleToStr(gd_136, l_digits_0), DoubleToStr(gd_128, l_digits_0), DoubleToStr(gd_144, l_digits_0), gd_152);
   }
}

int UpdateHistoryFile(int ai_0, bool ai_4 = FALSE) {
   int li_8;
   datetime lt_unused_20;
   int li_12 = 60 * gi_112;
   if (ai_4) {
      gi_160 = Time[ai_0] / li_12;
      gi_160 *= li_12;
      gd_120 = Open[ai_0];
      gd_128 = Low[ai_0];
      gd_136 = High[ai_0];
      gd_144 = Close[ai_0];
      gd_152 = Volume[ai_0];
      li_8 = ai_0 - 1;
      if (g_file_104 >= 0) gi_164 = FileTell(g_file_104);
      if (g_file_108 >= 0) gi_168 = FileTell(g_file_108);
   } else {
      li_8 = ai_0;
      if (g_file_104 >= 0) FileSeek(g_file_104, gi_164, SEEK_SET);
      if (g_file_108 >= 0) FileSeek(g_file_108, gi_168, SEEK_SET);
   }
   if (li_8 < 0) return (-1);
   int l_count_16 = 0;
   while (li_8 >= 0) {
      lt_unused_20 = Time[li_8];
      if (gd_136 - gd_128 >= tick_range * Point) {
         WriteHistoryData();
         l_count_16++;
         gi_160 += li_12;
         gd_120 = gd_144;
         gd_128 = gd_144;
         gd_136 = gd_144;
         gd_144 = Close[li_8];
         gd_152 = 0;
      } else {
         gd_152 += 1.0;
         if (Low[li_8] < gd_128) gd_128 = Low[li_8];
         if (High[li_8] > gd_136) gd_136 = High[li_8];
         gd_144 = Close[li_8];
      }
      li_8--;
   }
   if (g_file_104 >= 0) gi_164 = FileTell(g_file_104);
   if (g_file_108 >= 0) gi_168 = FileTell(g_file_108);
   WriteHistoryData();
   l_count_16++;
   if (g_file_104 >= 0) FileFlush(g_file_104);
   if (g_file_108 >= 0) FileFlush(g_file_108);
   return (l_count_16);
}

int UpdateChartWindow() {
   if (g_file_104 < 0) return (-1);
   if (gi_172 == 0) gi_172 = WindowHandle(Symbol(), gi_112);
   if (gi_172 != 0) {
      if (IsDllsAllowed() == FALSE) {
         DebugMsg("Dll calls must be allowed");
         return (-1);
      }
      if (PostMessageA(gi_172, WM_COMMAND, 33324, 0) == 0) gi_172 = 0;
      else return (0);
   }
   return (-1);
}

int reinit() {
   deinit();
   init();
   g_time_176 = Time[Bars - 1];
   g_time_180 = Time[0];
   g_bars_184 = Bars;
   return (0);
}

int IsDataChanged() {
   bool li_ret_0 = FALSE;
   if (g_volume_196 != Volume[0]) {
      g_volume_196 = Volume[0];
      li_ret_0 = TRUE;
   }
   if (g_time_192 != Time[0]) {
      g_time_192 = Time[0];
      li_ret_0 = TRUE;
   }
   if (g_bars_188 != Bars) {
      g_bars_188 = Bars;
      li_ret_0 = TRUE;
   }
   return (li_ret_0);
}

int CheckNewData() {
   if (Bars < 2) {
      DebugMsg("Data not loaded, only " + Bars + " Bars");
      return (-1);
   }
   string ls_0 = AccountServer();
   if (ls_0 == "") {
      DebugMsg("No server connected");
      return (-1);
   }
   if (gs_200 != ls_0) {
      DebugMsg("Server changed from " + gs_200 + " to " + ls_0);
      gs_200 = ls_0;
      reinit();
      return (-1);
   }
   if (!IsDataChanged()) return (-1);
   if (Time[Bars - 1] != g_time_176) {
      DebugMsg("Start time changed, new history loaded or server changed");
      reinit();
      return (-1);
   }
   for (int l_index_8 = 0; l_index_8 < Bars; l_index_8++)
      if (Time[l_index_8] <= g_time_180) break;
   if (l_index_8 >= Bars || Time[l_index_8] != g_time_180) {
      DebugMsg("End time " + TimeToStr(g_time_180) + " not found");
      reinit();
      return (-1);
   }
   int li_12 = Bars - l_index_8;
   if (li_12 != g_bars_184) {
      DebugMsg("Data loaded, cnt is " + li_12 + " LastBarCount is " + g_bars_184);
      reinit();
      return (-1);
   }
   g_bars_184 = Bars;
   g_time_180 = Time[0];
   return (l_index_8);
}

int start() {
   int li_0;
   if (!Enabled) return (0);
   if (gi_84 != 0) {
      li_0 = GetTickCount();
      if (MathAbs(li_0 - gi_208) < gi_84) return (0);
      gi_208 = li_0;
   }
   int li_4 = CheckNewData();
   if (li_4 < 0) return (0);
   UpdateHistoryFile(li_4);
   UpdateChartWindow();
   return (0);
}