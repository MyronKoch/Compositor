import AppKit
import Testing
@testable import Compositor

@MainActor
struct FontMenuFacesTests {
    @Test func listsTheReportedFacesSortedWithTheOneInUse() {
        // A face in use stays listed even when nothing installed answers to it, so the menu can still show it.
        let names = FontMenuFaces.names(available: ["Courier", "Avenir-Book"], inUse: ["", "NotInstalled-Regular"])
        #expect(names == ["Avenir-Book", "Courier", "NotInstalled-Regular"])
    }

    @Test func aFaceInUseBringsItsFamily() {
        let names = FontMenuFaces.names(available: [], inUse: ["Helvetica-Bold"])
        #expect(names.contains("Helvetica"))
        #expect(names.contains("Helvetica-Oblique"))
        #expect(names == names.sorted())
    }

    /// Rockwell ships with macOS but is left out of `availableFonts`; text set in it must still offer Bold.
    @Test(.enabled(if: NSFont(name: "Rockwell-Bold", size: 12) != nil))
    func aFamilyMacOSDoesNotListStillOffersItsFaces() {
        let names = FontMenuFaces.names(available: NSFontManager.shared.availableFonts, inUse: ["Rockwell-Regular"])
        #expect(names.contains("Rockwell-Bold"))
        #expect(names.contains("Rockwell-Italic"))
        #expect(names.contains("Rockwell-BoldItalic"))
    }
}
